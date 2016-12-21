//
//  TodayViewController.swift
//  kuStudy Today Extension
//
//  Created by 구범모 on 2015. 6. 6..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import NotificationCenter
import kuStudyKit
import Localize_Swift

enum State {
    case loading, loaded, error(Error)
}

class TodayViewController: UIViewController {
    @IBOutlet weak var noticeView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var table: UITableView!
    
    fileprivate var noticeHeight: NSLayoutConstraint!
    fileprivate var contentHeight: NSLayoutConstraint!
    fileprivate var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var noticeHelperLabel: UILabel!
    
    @IBOutlet var nameLabels: [UILabel]!
    @IBOutlet var availableLabels: [UILabel]!
    
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    
    var state = State.loading {
        didSet {
            switch state {
            case .loading:
                noticeLabel.text = "kuStudy.Today.Loading".localized()
                noticeHelperLabel.text = ""
            case .loaded:
                noticeLabel.text = ""
                noticeHelperLabel.text = "kuStudy.Today.TapToRefresh".localized()
            case .error(let error):
                noticeLabel.text = error.localizedDescription
                noticeHelperLabel.text = "kuStudy.Today.TapToRefresh".localized()
            }
            updateView()
        }
    }
    
    var summaryData = SummaryData() {
        didSet {
            reorder()
            studyingLabel.text = summaryData.usedSeats!.readable + "kuStudy.Today.Studying".localized()
        }
    }
    
    var orderedLibraryIds: [String]!
    
    private var updated = Date() {
        didSet {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            let updatedString = formatter.string(from: updated)
            updatedLabel.text = "kuStudy.Today.Updated".localized() + updatedString
        }
    }
    
    // MARK: - Setup
    fileprivate func setup() {
        table.delegate = self
        table.dataSource = self
        noticeHeight = noticeView.heightAnchor.constraint(equalToConstant: 110)
        contentHeight = contentView.heightAnchor.constraint(equalToConstant: 0)
        tableHeight = table.heightAnchor.constraint(equalToConstant: 0)
        noticeHeight.isActive = true
        contentHeight.isActive = true
        tableHeight.isActive = true
        registerPreference()
        listenToPreferenceChange()
        
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // iOS 9 workaround: http://stackoverflow.com/questions/26309364/uitableview-in-a-today-extension-not-receiving-row-taps
            view.backgroundColor = UIColor(white: 1, alpha: 0.01)
        }
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    // MARK: Action
    func openApp(libraryId: String = "") {
        guard let url = URL(string: "kustudy://?libraryId=\(libraryId)") else { return }
        extensionContext?.open(url, completionHandler: { (completed) in
            
        })
    }
    
    fileprivate func updateData() {
        state = .loading
        kuStudy.requestSummaryData(onLibrarySuccess: nil, onFailure: { [weak self] (error) in
            self?.state = .error(error)
        }) { [weak self] (summary) in
            self?.updated = Date()
            self?.summaryData = summary
            self?.state = .loaded
        }
    }
    
    func updateView() {
        switch state {
        case .loading:
            noticeHeight.constant = 110
            contentHeight.constant = 0
            tableHeight.constant = 0
        case .loaded:
            noticeHeight.constant = 0
            contentHeight.constant = 110
            tableHeight.constant = 0
            
            let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
            orderedLibraryIds = defaults.array(forKey: "todayExtensionOrder") as! [String]
            tableHeight.constant = CGFloat(orderedLibraryIds.count) * table.rowHeight
            
            // TODO: Hide main library labels if count is less than 3
            
            if summaryData.libraries.count > 0 {
                
                for (index, library) in summaryData.libraries.enumerated() {
                    if index > 3 { break }
                    let nameLabel = nameLabels.filter({ $0.tag == index }).first
                    let availableLabel = availableLabels.filter({ $0.tag == index }).first
                    nameLabel?.text = library.libraryName
                    availableLabel?.text = library.availableSeats.readable
                }
                
                tableHeight.constant = CGFloat(summaryData.libraries.count) * table.rowHeight
                table.reloadData()
            } else {
                tableHeight.constant = 0
            }
        case .error(_):
            noticeHeight.constant = 110
            contentHeight.constant = 0
            tableHeight.constant = 0
        }
    }
    
    // MARK: - Helper
    private func reorder() {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        orderedLibraryIds = defaults.array(forKey: "todayExtensionOrder") as! [String]
        
        var ordered = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = summaryData.libraries.filter({ $0.libraryId! == libraryId }).first else { continue }
            ordered.append(libraryData)
        }
        summaryData.libraries = ordered
    }
}

// MARK: - Widget
extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(.noData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            preferredContentSize = maxSize
        case .expanded:
            let width = maxSize.width
            let height = contentHeight.constant + CGFloat(summaryData.libraries.count) * table.rowHeight
            preferredContentSize = CGSize(width: width, height: height)
        }
    }
}
