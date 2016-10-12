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

class TodayViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate var summaryData = SummaryData()
    fileprivate var orderedLibraryIds: [String]!
    
    // MARK: View
    override func viewDidLoad() {
        func registerPreference() {
            let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
            let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
            defaults.register(defaults: ["libraryOrder": libraryOrder,
                "todayExtensionOrder": libraryOrder,
                "todayExtensionHidden": []])
            defaults.synchronize()
        }
        
        super.viewDidLoad()
        registerPreference()
        listenToPreferenceChange()
        tableView.delegate = self
        tableView.dataSource = self
        updateView()
        
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // iOS 9 workaround: http://stackoverflow.com/questions/26309364/uitableview-in-a-today-extension-not-receiving-row-taps
            view.backgroundColor = UIColor(white: 1, alpha: 0.01)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    // MARK: Action
    fileprivate func updateData() {
        kuStudy.requestSummaryData(onLibrarySuccess: { (libraryData) in
            
            }, onFailure: { (error) in
                
            }) { [weak self] (summaryData) in
                self?.summaryData = summaryData
                self?.updateView()
        }
    }
    
    fileprivate func updateView() {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        orderedLibraryIds = defaults.array(forKey: "todayExtensionOrder") as! [String]
        tableViewHeightConstraint.constant = CGFloat(orderedLibraryIds.count) * tableView.rowHeight
        
        reorderLibraryData()
        if summaryData.libraries.count > 0 {
            tableViewHeightConstraint.constant = CGFloat(summaryData.libraries.count) * tableView.rowHeight
            tableView.reloadData()
        } else {
            tableViewHeightConstraint.constant = 0
        }
    }
    
    fileprivate func reorderLibraryData() {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        orderedLibraryIds = defaults.array(forKey: "todayExtensionOrder") as! [String]
        
        var orderedLibraryData = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = summaryData.libraries.filter({ $0.libraryId! == libraryId }).first else { continue }
            orderedLibraryData.append(libraryData)
        }
        summaryData.libraries = orderedLibraryData
    }
}

// MARK: - Table view
extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let libraryId = summaryData.libraries[indexPath.row].libraryId else { return }
        guard let url = URL(string: "kustudy://?libraryId=\(libraryId)") else { return }
        extensionContext?.open(url, completionHandler: { (completed) in
            
        })
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryData.libraries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let libraryData = summaryData.libraries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell", for: indexPath) as! LibraryTableViewCell
        cell.populate(libraryData)
        return cell
    }
}

// MARK: - Widget
extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdate(_ completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("Widget update")
//        updateData()
//        completionHandler(.NewData)
        completionHandler(.noData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 0)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            preferredContentSize = maxSize
        case .expanded:
            preferredContentSize = CGSize(width: maxSize.width, height: CGFloat(summaryData.libraries.count) * tableView.rowHeight)
        }
    }
}

// MARK: - Notification
extension TodayViewController {
    fileprivate func listenToPreferenceChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(handle(preferenceChanged:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc func handle(preferenceChanged notification: Notification) {
        updateView()
    }
}
