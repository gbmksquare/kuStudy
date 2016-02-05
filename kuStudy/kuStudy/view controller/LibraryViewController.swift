//
//  LibraryViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import DZNEmptyDataSet

class LibraryViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    
    lazy var dataSource = LibraryDataSource()
    private var refreshControl = UIRefreshControl()
    
    // MARK: Model
    var libraryId: Int!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchLibrary()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startHandoff()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        userActivity?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
    
    // MARK: Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.emptyDataSetSource = dataSource
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "fetchLibrary:", forControlEvents: .ValueChanged)
    }
    
    private var gradient: CAGradientLayer?
    
    private func setupGradient() {
        self.gradient?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        self.gradient = gradient
        
        gradient.frame = summaryView.bounds
        gradient.colors = kuStudyGradientColor
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        summaryView.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    // MARK: Handoff
    private func startHandoff() {
        let activity = NSUserActivity(activityType: kuStudyHandoffLibrary)
        activity.title = dataSource.library?.key
        activity.addUserInfoEntriesFromDictionary(["libraryId": libraryId])
        activity.becomeCurrent()
        userActivity = activity
    }
    
    // MARK: Action
    @objc private func fetchLibrary(sender: UIRefreshControl? = nil) {
        NetworkActivityManager.increaseActivityCount()
        dataSource.fetchData(libraryId,
            success: { [unowned self] () -> Void in
                self.updateDataInView()
                NetworkActivityManager.decreaseActivityCount()
                sender?.endRefreshing()
            }) { (error) -> Void in
                NetworkActivityManager.decreaseActivityCount()
                sender?.endRefreshing()
        }
    }
    
    private func updateDataInView() {
        if let library = dataSource.library {
            let libraryViewModel = LibraryViewModel(library: library)
            libraryNameLabel.text = libraryViewModel.name
            availableLabel.text = libraryViewModel.availableString
            usedLabel.text = libraryViewModel.usedString
        }
        tableView.reloadData()
    }
}
