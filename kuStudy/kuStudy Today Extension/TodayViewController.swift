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

enum DataSourceState {
    case Loaded, Fetching, Error
}

class TodayViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var totalUsedLabel: UILabel!
    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet weak var emptyDataViewConstraint: NSLayoutConstraint!
    
    private var summaryData = SummaryData()
    private var dataState: DataSourceState = .Fetching
    private var error: NSError?
    
    private var orderedLibraryIds: [String]!
    
    // MARK: View
    override func viewDidLoad() {
        func registerDefaultPreferences() {
            let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
            let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
            defaults.registerDefaults(["libraryOrder": libraryOrder,
                "todayExtensionOrder": libraryOrder,
                "todayExtensionHidden": []])
            defaults.synchronize()
        }
        
        super.viewDidLoad()
        addObserver()
        registerDefaultPreferences()
        tableView.delegate = self
        tableView.dataSource = self
        tableViewHeightConstraint.constant = 0
        footerHeightConstraint.constant = 0
        emptyDataViewConstraint.constant = 50
        emptyDataLabel.text = "Loading data..."
        updateData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: Action
    private func updateData() {
        dataState = .Fetching
        error = nil
        kuStudy.requestSummaryData(onLibrarySuccess: { [weak self] (libraryData) in
                self?.dataState = .Loaded
            }, onFailure: { [weak self] (error) in
                self?.error = error
                self?.dataState = .Error
            }) { [weak self] (summaryData) in
                self?.summaryData = summaryData
                self?.reorderLibraryData()
                self?.updateView()
        }
    }
    
    private func updateView() {
        if summaryData.libraries.count > 0 {
            tableViewHeightConstraint.constant = CGFloat(summaryData.libraries.count) * tableView.rowHeight
            footerHeightConstraint.constant = 50
            emptyDataViewConstraint.constant = 0
            tableView.reloadData()
        
            totalUsedLabel.text = summaryData.totalSeats!.readableFormat + " people are studying."
            updatedTimeLabel.text = "Updated: " + NSDate().description
            emptyDataLabel.text = dataState == .Loaded ? "" : "Error occurrred."
        } else {
            tableViewHeightConstraint.constant = 0
            footerHeightConstraint.constant = 0
            emptyDataViewConstraint.constant = 50
            emptyDataLabel.text = self.error?.localizedDescription
        }
    }
    
    private func reorderLibraryData() {
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        orderedLibraryIds = defaults.arrayForKey("libraryOrder") as! [String]
        
        var orderedLibraryData = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = summaryData.libraries.filter({ $0.libraryId! == libraryId }).first else { continue }
            orderedLibraryData.append(libraryData)
        }
        summaryData.libraries = orderedLibraryData
    }
}

// MARK:
// MARK: Table view
extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
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

// MARK:
// MARK: Widget
extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        print("Widget update")
//        updateData()
//        completionHandler(.NewData)
        completionHandler(.NoData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
    }
}

// MARK:
// MARK: Notification
extension TodayViewController {
    private func addObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleUserDefaultsDidChange(_:)), name: NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    @objc func handleUserDefaultsDidChange(notification: NSNotification) {
        reorderLibraryData()
        tableView.reloadData()
    }
}
