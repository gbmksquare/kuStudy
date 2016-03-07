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
    
    @IBOutlet weak var libraryImageView: UIImageView!
    @IBOutlet weak var shadowView: ShadowGradientView!
    
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    
    private var refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dataSource = LibraryDataSource()
    
    // MARK: Model
    var libraryId: Int!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
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
        shadowView.refreshGradientLayout()
    }
    
    // MARK: Setup
    private func initialSetup() {
        libraryNameLabel.text = ""
        availableLabel.text = ""
        usedLabel.text = ""
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.emptyDataSetSource = dataSource
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "fetchLibrary:", forControlEvents: .ValueChanged)
    }
    
    // MARK: Action
    @objc private func fetchLibrary(sender: UIRefreshControl? = nil) {
        NetworkActivityManager.increaseActivityCount()
        dataSource.fetchData(libraryId,
            success: { [unowned self] () -> Void in
                self.updateDataInView()
                NetworkActivityManager.decreaseActivityCount()
                sender?.endRefreshing()
            }) { [unowned self] (error) -> Void in
                self.tableView.reloadData()
                NetworkActivityManager.decreaseActivityCount()
                sender?.endRefreshing()
        }
    }
    
    private func updateDataInView() {
        if let library = dataSource.library {
            libraryNameLabel.text = library.name
            availableLabel.text = library.availableString
            usedLabel.text = library.usedString
            let photo = ImageProvider.sharedProvider.imageForLibrary(library.id)
            libraryImageView.image = photo?.image
        }
        tableView.reloadData()
    }
}

// MARK: Handoff
extension LibraryViewController {
    // MARK: Handoff
    private func startHandoff() {
        let activity = NSUserActivity(activityType: kuStudyHandoffLibrary)
        activity.title = dataSource.library?.key
        activity.addUserInfoEntriesFromDictionary(["libraryId": libraryId])
        activity.becomeCurrent()
        userActivity = activity
    }
}
