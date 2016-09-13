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
    
    private var summaryData = SummaryData()
    private var orderedLibraryIds: [String]!
    
    // MARK: View
    override func viewDidLoad() {
        func registerPreference() {
            let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
            let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
            defaults.registerDefaults(["libraryOrder": libraryOrder,
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
            extensionContext?.widgetLargestAvailableDisplayMode = .Expanded
        } else {
            // iOS 9 workaround: http://stackoverflow.com/questions/26309364/uitableview-in-a-today-extension-not-receiving-row-taps
            view.backgroundColor = UIColor(white: 1, alpha: 0.01)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    // MARK: Action
    private func updateData() {
        kuStudy.requestSummaryData(onLibrarySuccess: { (libraryData) in
            
            }, onFailure: { (error) in
                
            }) { [weak self] (summaryData) in
                self?.summaryData = summaryData
                self?.updateView()
        }
    }
    
    private func updateView() {
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        orderedLibraryIds = defaults.arrayForKey("todayExtensionOrder") as! [String]
        tableViewHeightConstraint.constant = CGFloat(orderedLibraryIds.count) * tableView.rowHeight
        
        reorderLibraryData()
        if summaryData.libraries.count > 0 {
            tableViewHeightConstraint.constant = CGFloat(summaryData.libraries.count) * tableView.rowHeight
            tableView.reloadData()
        } else {
            tableViewHeightConstraint.constant = 0
        }
    }
    
    private func reorderLibraryData() {
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        orderedLibraryIds = defaults.arrayForKey("todayExtensionOrder") as! [String]
        
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let libraryId = summaryData.libraries[indexPath.row].libraryId else { return }
        guard let url = NSURL(string: "kustudy://?libraryId=\(libraryId)") else { return }
        extensionContext?.openURL(url, completionHandler: { (completed) in
            
        })
    }
    
    // Data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryData.libraries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let libraryData = summaryData.libraries[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("libraryCell", forIndexPath: indexPath) as! LibraryTableViewCell
        cell.populate(libraryData)
        return cell
    }
}

// MARK: - Widget
extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        print("Widget update")
//        updateData()
//        completionHandler(.NewData)
        completionHandler(.NoData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 0)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .Compact:
            preferredContentSize = maxSize
        case .Expanded:
            preferredContentSize = CGSize(width: maxSize.width, height: CGFloat(summaryData.libraries.count) * tableView.rowHeight)
        }
    }
}

// MARK: - Notification
extension TodayViewController {
    private func listenToPreferenceChange() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handle(preferenceChanged:)), name: NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    @objc func handle(preferenceChanged notification: NSNotification) {
        updateView()
    }
}
