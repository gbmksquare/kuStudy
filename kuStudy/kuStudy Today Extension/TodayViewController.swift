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

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var totalUsedLabel: UILabel!
    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet weak var emptyDataViewConstraint: NSLayoutConstraint!
    
    private lazy var dataSource = SummaryDataSource()
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.fetchData(onFetchDataSuccess, failure: onFetchDataFailure)
    }
    
    private func onFetchDataSuccess() {
        tableViewHeightConstraint.constant = CGFloat(dataSource.libraries.count) * tableView.rowHeight
        footerHeightConstraint.constant = 50
        emptyDataViewConstraint.constant = 0
        tableView.reloadData()
        
        guard let summary = dataSource.summary else { return }
        
        totalUsedLabel.text = summary.usedString + " people are studying."
        updatedTimeLabel.text = "Updated: " + summary.updatedTimeString
        emptyDataLabel.text = dataSource.dataState == .Loaded ? "" : "Error occurred."
    }
    
    private func onFetchDataFailure(error: NSError) {
        tableViewHeightConstraint.constant = 0
        footerHeightConstraint.constant = 0
        emptyDataViewConstraint.constant = 50
        emptyDataLabel.text = error.localizedDescription
    }
}

// MARK: Setup
extension TodayViewController {
    private func initialSetup() {
        addObserver()
        setupTableView()
        tableViewHeightConstraint.constant = 0
        footerHeightConstraint.constant = 0
        emptyDataViewConstraint.constant = 50
        emptyDataLabel.text = "Loading data..."
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
    }
    
    private func addObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleUserDefaultsDidChange:", name: NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    @objc func handleUserDefaultsDidChange(notification: NSNotification) {
        tableView.reloadData()
    }
}

// MARK: Widget
extension TodayViewController {
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        print("Widget update")
        dataSource.fetchData(
            { [weak self] () -> Void in
                self?.onFetchDataSuccess()
                completionHandler(.NewData)
            }) { [weak self] (error) -> Void in
                self?.onFetchDataFailure(error)
                completionHandler(.Failed)
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
    }
}
