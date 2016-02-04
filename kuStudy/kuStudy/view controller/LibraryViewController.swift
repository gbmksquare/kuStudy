//
//  LibraryViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    
    lazy var dataSource = LibraryDataSource()
    
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
    private func fetchLibrary() {
        NetworkActivityManager.increaseActivityCount()
        dataSource.fetchData(libraryId,
            success: { [unowned self] () -> Void in
                self.updateDataInView()
                NetworkActivityManager.decreaseActivityCount()
            }) { (error) -> Void in
                NetworkActivityManager.decreaseActivityCount()
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
