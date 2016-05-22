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
    case Fetching, Error
}

class TodayViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var totalUsedLabel: UILabel!
    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet weak var emptyDataViewConstraint: NSLayoutConstraint!
    
    private var libraryDataArray = [LibraryData]()
    private var dataState: DataSourceState = .Fetching
    private var error: NSError?
    
    private var orderedLibraryIds: [String]!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        tableView.delegate = self
        tableView.dataSource = self
        tableViewHeightConstraint.constant = 0
        footerHeightConstraint.constant = 0
        emptyDataViewConstraint.constant = 50
        emptyDataLabel.text = "Loading data..."
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    // MARK: Action
    private func updateData() {
        dataState = .Fetching
        error = nil
        libraryDataArray.removeAll(keepCapacity: true)
        kuStudy.requestAllLibraryData(onLibrarySuccess: { [weak self] (libraryData) in
                self?.libraryDataArray.append(libraryData)
            }, onFailure: { [weak self] (error) in
                self?.error = error
                self?.dataState = .Error
            }) { [weak self] (summaryData) in
//                self?.reorderLibraryData()
                self?.updateView()
        }
    }
    
    private func updateView() {
        if libraryDataArray.count > 0 {
            tableViewHeightConstraint.constant = CGFloat(libraryDataArray.count) * tableView.rowHeight
            footerHeightConstraint.constant = 50
            emptyDataViewConstraint.constant = 0
            tableView.reloadData()
        //
        //        guard let summary = dataSource.summary else { return }
        //
        //        totalUsedLabel.text = summary.usedString + " people are studying."
        //        updatedTimeLabel.text = "Updated: " + summary.updatedTimeString
        //        emptyDataLabel.text = dataSource.dataState == .Loaded ? "" : "Error occurred."
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
            guard let libraryData = self.libraryDataArray.filter({ $0.libraryId! == libraryId }).first else { continue }
            orderedLibraryData.append(libraryData)
        }
        libraryDataArray = orderedLibraryData
    }
}

// MARK:
// MARK: Table view
extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let libraryData = libraryDataArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("libraryCell", forIndexPath: indexPath) as! LibraryTableViewCell
        cell.populate(libraryData)
        return cell
//        
//        let libraryId = orderedLibraryIds[indexPath.row]
//        let library = libraries.filter({ $0.id == Int(libraryId)! }).first
//        let cell = tableView.dequeueReusableCellWithIdentifier("libraryCell", forIndexPath: indexPath) as! LibraryTableViewCell
//        if let library = library {
//            cell.populate(library)
//        }
//        return cell
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
