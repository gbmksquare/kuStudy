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
    
    @IBOutlet weak var libraryImageView: UIImageView!
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    
    private var gradient: CAGradientLayer?
    private var shadowGradient: CAGradientLayer?
    
    lazy var dataSource = LibraryDataSource()
    private var refreshControl = UIRefreshControl()
    
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
        setupGradient()
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
        tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "fetchLibrary:", forControlEvents: .ValueChanged)
    }
    
    private func setupGradient() {
        // Background
        // TODO: Remove background gradient later
        self.gradient?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        self.gradient = gradient
        
        gradient.frame = summaryView.bounds
        gradient.colors = kuStudyGradientColor
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        summaryView.layer.insertSublayer(gradient, atIndex: 0)
        
        // Shadow
        self.shadowGradient?.removeFromSuperlayer()
        
        let shadowGradient = CAGradientLayer()
        self.shadowGradient = shadowGradient
        
        shadowGradient.frame = libraryImageView.bounds
        shadowGradient.colors = [UIColor(white: 0, alpha: 0).CGColor, UIColor(white: 0.1, alpha: 0.55).CGColor, UIColor(white: 0.1, alpha: 0.75).CGColor]
        shadowGradient.startPoint = CGPoint(x: 0, y: 0)
        shadowGradient.endPoint = CGPoint(x: 0, y: 1)
        libraryImageView.layer.addSublayer(shadowGradient)
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
            let libraryViewModel = LibraryViewModel(library: library)
            libraryNameLabel.text = libraryViewModel.name
            availableLabel.text = libraryViewModel.availableString
            usedLabel.text = libraryViewModel.usedString
            if let imageName = libraryViewModel.imageName {
                libraryImageView.image = UIImage(named: imageName)
            }
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
