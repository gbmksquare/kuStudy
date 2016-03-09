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
    @IBOutlet weak var shadowView: ShadowGradientView!
    @IBOutlet weak var libraryImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var photographerLabel: UILabel!
    
    private var refreshControl = UIRefreshControl()
    lazy var dataSource = LibraryDataSource()
    var passedLibrary: Library!
    
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
        shadowView.updateGradientLayout()
    }
    
    // MARK: Action
    @objc private func fetchLibrary(sender: UIRefreshControl? = nil) {
        NetworkActivityManager.increaseActivityCount()
        dataSource.fetchData(passedLibrary.id,
            success: { [unowned self] () -> Void in
                self.reloadData()
                sender?.endRefreshing()
                NetworkActivityManager.decreaseActivityCount()
            }) { [unowned self] (error) -> Void in
                self.reloadData()
                sender?.endRefreshing()
                NetworkActivityManager.decreaseActivityCount()
        }
    }
}

// MARK: Setup
extension LibraryViewController {
    private func initialSetup() {
        libraryNameLabel.text = ""
        availableLabel.text = "- seats are available."
        usedLabel.text = "- people are studying."
        setupTableView()
        configureHeader()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.emptyDataSetSource = dataSource
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "fetchLibrary:", forControlEvents: .ValueChanged)
    }
}

// MARK: Data
extension LibraryViewController {
    private func configureHeader() {
        libraryNameLabel.text = passedLibrary.name
        
        let photo = passedLibrary.photo
        photographerLabel.text = photo != nil ? "Photography by " + photo!.photographer.name : ""
        libraryImageView.image = photo?.image
    }
    
    private func reloadData() {
        if let library = dataSource.library {
            availableLabel.text = library.availableString + " seats are available."
            usedLabel.text = library.usedString + " people are studying."
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
        activity.addUserInfoEntriesFromDictionary(["libraryId": passedLibrary.id])
        activity.becomeCurrent()
        userActivity = activity
    }
}
