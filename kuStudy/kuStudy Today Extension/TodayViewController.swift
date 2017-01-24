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
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var noticeHelperLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var liberalArtCampusLabel: UILabel!
    @IBOutlet weak var liberalArtCampusDataLabel: UILabel!
    @IBOutlet weak var scienceCampusLabel: UILabel!
    @IBOutlet weak var scienceCampusDataLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var tableViewHeight: NSLayoutConstraint!
    var orderedLibraryIds: [String]!
    
    var state = State.loading {
        didSet {
            switch state {
            case .loading:
                noticeLabel.text = "kuStudy.Today.Loading".localized()
                noticeHelperLabel.text = ""
            case .loaded:
                noticeLabel.text = ""
                noticeHelperLabel.text = ""
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
    
    // MARK: - Setup
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        registerPreference()
        listenToPreferenceChange()
        
        contentView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        let height = tableView.rowHeight * CGFloat(summaryData.libraries.count)
        tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: height)
        tableViewHeight.isActive = true
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        liberalArtCampusLabel.text = "kuStudy.Today.LiberalArtCampus".localized() + " : "
        scienceCampusLabel.text = "kuStudy.Today.ScienceCampus".localized() + " : "
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
            self?.summaryData = summary
            self?.state = .loaded
        }
    }
    
    func updateView() {
        let width = extensionContext!.widgetMaximumSize(for: .expanded).width
        switch state {
        case .loading:
            hideContents()
            showNoticeView()
            setCompactHeight(maxSize: CGSize(width: width, height: 110))
        case .loaded:
            showContents()
            hideNoticeView()
            
            let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
            orderedLibraryIds = defaults.array(forKey: "todayExtensionOrder") as! [String]
            
            if summaryData.libraries.count > 0 {
                liberalArtCampusDataLabel.text = (summaryData.usedSeatsInLiberalArtCampus?.readable ?? "0") + "kuStudy.Today.Studying".localized()
                scienceCampusDataLabel.text = (summaryData.usedSeatsInScienceCampus?.readable ?? "0") + "kuStudy.Today.Studying".localized()
                
                let height = CGFloat(summaryData.libraries.count) * tableView.rowHeight
                tableViewHeight.constant = height
                setExpandedHeight(maxSize: CGSize(width: width, height: height))
                tableView.reloadData()
            } else {
                tableViewHeight.constant = 0
                setCompactHeight(maxSize: CGSize(width: width, height: 110))
            }
        case .error(_):
            hideContents()
            showNoticeView()
            setCompactHeight(maxSize: CGSize(width: width, height: 110))
        }
    }
    
    fileprivate func showContents() {
        contentView.alpha = 1
        tableView.alpha = 1
    }
    
    fileprivate func hideContents() {
        contentView.alpha = 0
        tableView.alpha = 0
    }
    
    fileprivate func showNoticeView() {
        noticeView.isHidden = false
    }
    
    fileprivate func hideNoticeView() {
        noticeView.isHidden = true
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
    // Widget
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(.noData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            setCompactHeight(maxSize: maxSize)
        case .expanded:
            setExpandedHeight(maxSize: maxSize)
        }
    }
    
    // Height
    fileprivate func setCompactHeight(maxSize: CGSize) {
        preferredContentSize = maxSize
    }
    
    fileprivate func setExpandedHeight(maxSize: CGSize) {
        let width = maxSize.width
        let height = 110 + CGFloat(summaryData.libraries.count) * tableView.rowHeight
        preferredContentSize = CGSize(width: width, height: height)
    }
}
