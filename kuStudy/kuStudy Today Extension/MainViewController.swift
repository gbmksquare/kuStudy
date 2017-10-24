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

class MainViewController: UIViewController {
    @IBOutlet private weak var noticeView: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var mainViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var laCampusPlaceholderLabel: UILabel!
    @IBOutlet private weak var scCampusPlaceholderLabeL: UILabel!
    
    @IBOutlet private weak var usedLabel: UILabel!
    @IBOutlet private weak var laCampusUsedLabel: UILabel!
    @IBOutlet private weak var scCampusUsedLabel: UILabel!
    
    private var occupied: Int?
    private var laCampusUsed: Int?
    private var scCampusUsed: Int?
    private var data: SummaryData? {
        didSet {
            reorderData()
            updateView()
        }
    }
    
    private var preference: UserDefaults {
        return UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
    }
    
    private var estimatedTableHeight: CGFloat {
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
        
        mainViewHeight.constant = extensionContext?.widgetMaximumSize(for: .compact).height ?? 110
        
        // Localize
        usedLabel.text = Localizations.Main.Label.Studying(Localizations.Main.Label.NoData)
        laCampusPlaceholderLabel.text = Localizations.Main.Label.LiberalArtCampus
        scCampusPlaceholderLabeL.text = Localizations.Main.Label.ScienceCampus
        laCampusUsedLabel.text = Localizations.Main.Label.Studying(Localizations.Main.Label.NoData)
        scCampusUsedLabel.text = Localizations.Main.Label.Studying(Localizations.Main.Label.NoData)
    }
    
    private func registerPreference() {
        let libraryOrder = LibraryType.allTypes().map({ $0.identifier })
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
            guard let libraryData = data.libraries.filter({ $0.libraryType!.identifier == libraryId }).first else { continue }
            ordered.append(libraryData)
        }
        data.libraries = ordered
    }
    
    private func updateData() {
        kuStudy.requestSummaryData(onLibrarySuccess: nil, onFailure: {(error) in
            
        }) { [weak self] (summary) in
            if summary.libraries.count > 0 {
                self?.occupied = summary.occupied
                self?.laCampusUsed = summary.occupiedInLiberalArtCampus
                self?.scCampusUsed = summary.occupiedInScienceCampus
                self?.data = summary
            } else {
                self?.occupied = nil
                self?.laCampusUsed = nil
                self?.scCampusUsed = nil
                self?.data = nil
            }
        }
    }
    
    private func updateView() {
        // Data available
        if let data = data {
            hideNotice()
            
            // Update content
            usedLabel.text = Localizations.Main.Label.Studying(occupied?.readable ?? Localizations.Main.Label.NoData)
            laCampusUsedLabel.text = Localizations.Main.Label.Studying(laCampusUsed?.readable ?? Localizations.Main.Label.NoData)
            scCampusUsedLabel.text = Localizations.Main.Label.Studying(scCampusUsed?.readable ?? Localizations.Main.Label.NoData)
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
        guard let libraryId = data?.libraries[indexPath.row].libraryType?.identifier else { return }
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
