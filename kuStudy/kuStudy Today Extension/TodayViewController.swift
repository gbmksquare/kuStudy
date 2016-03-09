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
        updateTableViewHeight()
        tableView.reloadData()
    }
    
    private func onFetchDataFailure(error: NSError) {
        // TODO: Show error message
    }
    
    // MARK: Action
    private func updateTableViewHeight() {
        tableViewHeightConstraint.constant = CGFloat(dataSource.libraries.count) * tableView.rowHeight
    }
}

// MARK: Setup
extension TodayViewController {
    private func initialSetup() {
        addObserver()
        setupTableView()
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
