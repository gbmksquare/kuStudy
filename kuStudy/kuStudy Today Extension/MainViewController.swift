//
//  MainViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 2. 1..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import NotificationCenter
import kuStudyKit
import Localize_Swift

class MainViewController: UIViewController {
    @IBOutlet fileprivate weak var noticeView: UIView!
    @IBOutlet fileprivate weak var mainView: UIView!
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    @IBOutlet fileprivate weak var laCampusPlaceholderLabel: UILabel!
    @IBOutlet fileprivate weak var scCampusPlaceholderLabeL: UILabel!
    
    @IBOutlet fileprivate weak var usedLabel: UILabel!
    @IBOutlet fileprivate weak var laCampusUsedLabel: UILabel!
    @IBOutlet fileprivate weak var scCampusUsedLabel: UILabel!
    
    fileprivate var used: Int?
    fileprivate var laCampusUsed: Int?
    fileprivate var scCampusUsed: Int?
    fileprivate var data: SummaryData? {
        didSet {
            reorderData()
            updateView()
        }
    }
    
    fileprivate var preference: UserDefaults {
        return UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
    }
    
    fileprivate var estimatedTableHeight: CGFloat {
        let count = preference.array(forKey: "todayExtensionOrder")?.count ?? 0
        return CGFloat(count) * tableView.rowHeight
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        registerPreference()
        observePreference()
        setup()
        updateData()
    }
    
    // MARK: - Observer
    private func observePreference() {
        NotificationCenter.default.addObserver(self, selector: #selector(handle(preferenceChanged:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc private func handle(preferenceChanged notificaiton: Notification) {
        updateView()
        extensionContext?.widgetLargestAvailableDisplayMode = estimatedTableHeight == 0 ? .compact : .expanded
    }
    
    // MARK: - Action
    func openMainApp(libraryId: String? = nil) {
        let url: URL
        if let libraryId = libraryId {
            url = URL(string: "kustudy://?libraryId=\(libraryId)")!
        } else {
            url = URL(string: "kustudy://")!
        }
        extensionContext?.open(url, completionHandler: { (completed) in
            
        })
    }
    
    @IBAction func tappedMainView(_ sender: UITapGestureRecognizer) {
        openMainApp()
    }
    
    // MARK: - Helper
    private func setup() {
        extensionContext?.widgetLargestAvailableDisplayMode = estimatedTableHeight == 0 ? .compact : .expanded
        
        // Localize
        usedLabel.text = "kuStudy.Today.EmptyData".localized() + "kuStudy.Today.Studying".localized()
        laCampusPlaceholderLabel.text = "kuStudy.Today.LiberalArtCampus".localized() + ": "
        scCampusPlaceholderLabeL.text = "kuStudy.Today.ScienceCampus".localized() + ": "
        laCampusUsedLabel.text =  "kuStudy.Today.EmptyData".localized()
        scCampusUsedLabel.text = "kuStudy.Today.EmptyData".localized()
    }
    
    private func registerPreference() {
        let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
        preference.register(defaults: ["libraryOrder": libraryOrder,
                                       "todayExtensionOrder": libraryOrder,
                                       "todayExtensionHidden": []])
        preference.synchronize()
    }
    
    private func reorderData() {
        guard let data = data else { return }
        
        let orderedLibraryIds = preference.array(forKey: "todayExtensionOrder") as! [String]
        
        var ordered = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = data.libraries.filter({ $0.libraryId! == libraryId }).first else { continue }
            ordered.append(libraryData)
        }
        data.libraries = ordered
    }
    
    fileprivate func updateData() {
        kuStudy.requestSummaryData(onLibrarySuccess: nil, onFailure: {(error) in
            
        }) { [weak self] (summary) in
            if summary.libraries.count > 0 {
                self?.used = summary.usedSeats
                self?.laCampusUsed = summary.usedSeatsInLiberalArtCampus
                self?.scCampusUsed = summary.usedSeatsInScienceCampus
                self?.data = summary
            } else {
                self?.used = nil
                self?.laCampusUsed = nil
                self?.scCampusUsed = nil
                self?.data = nil
            }
        }
    }
    
    fileprivate func updateView() {
        // Data available
        if let data = data {
            hideNotice()
            
            // Update content
            usedLabel.text = (used?.readable ?? "kuStudy.Today.EmptyData".localized()) + "kuStudy.Today.Studying".localized()
            laCampusUsedLabel.text = laCampusUsed?.readable ?? "kuStudy.Today.EmptyData".localized() + "kuStudy.Today.Studying".localized()
            scCampusUsedLabel.text = scCampusUsed?.readable ?? "kuStudy.Today.EmptyData".localized() + "kuStudy.Today.Studying".localized()
            tableView.reloadData()
            
            // Change height if needed
            let tableHeight = CGFloat(data.libraries.count) * tableView.rowHeight
            if tableHeight < estimatedTableHeight {
                updateHeight(tableHeight: tableHeight)
            }
        }
        // Data not available
        else {
            showNotice()
        }
    }
    
    private func updateHeight(tableHeight: CGFloat) {
        let maxSize = extensionContext!.widgetMaximumSize(for: .compact)
        let height = tableHeight + maxSize.height
        preferredContentSize = CGSize(width: maxSize.width, height: height)
    }
    
    private func showNotice() {
        noticeView.isHidden = false
        mainView.alpha = 0
        tableView.alpha = 0
    }
    
    private func hideNotice() {
        noticeView.isHidden = true
        mainView.alpha = 1
        tableView.alpha = 1
    }
}

// MARK: - Widget
extension MainViewController: NCWidgetProviding {
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(.noData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            preferredContentSize = maxSize
        case .expanded:
            let height = estimatedTableHeight + (extensionContext?.widgetMaximumSize(for: .compact).height ?? 110)
            preferredContentSize = CGSize(width: maxSize.width, height: height)
        }
    }
}

// MARK: - Table view
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let libraryId = data?.libraries[indexPath.row].libraryId else { return }
        openMainApp(libraryId: libraryId)
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.libraries.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell", for: indexPath) as! LibraryTableViewCell
        if let libraryData = data?.libraries[indexPath.row] {
            cell.populate(libraryData)
        }
        return cell
    }
}
