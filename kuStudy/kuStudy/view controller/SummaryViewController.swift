//
//  SummaryViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import DZNEmptyDataSet
import Localize_Swift

class SummaryViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    
    lazy var dataSource = SummaryDataSource()
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        fetchSummary()
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
    private func setupView() {
        navigationController?.setTransparentNavigationBar() // Transparent navigation bar
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.emptyDataSetSource = dataSource
        tableView.tableFooterView = UIView()
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
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "librarySegue":
                let destinationViewController = segue.destinationViewController as! LibraryViewController
                let libraryId: Int
                if sender is Int { // Handoff
                    libraryId = sender as! Int
                } else {
                    let selectedRow = tableView.indexPathForSelectedRow!.row
                    libraryId = dataSource.orderedLibraryIds[selectedRow]
                }
                destinationViewController.libraryId = libraryId
            default: break
            }
        }
    }
    
    // MARK: Handoff
    private func startHandoff() {
        let activity = NSUserActivity(activityType: kuStudyHandoffSummary)
        activity.title = "Summary"
        activity.becomeCurrent()
        userActivity = activity
    }
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        switch activity.activityType {
        case kuStudyHandoffSummary: break
        case kuStudyHandoffLibrary:
            let libraryId = activity.userInfo!["libraryId"]
            performSegueWithIdentifier("librarySegue", sender: libraryId)
        default: break
        }
        super.restoreUserActivityState(activity)
    }
    
    // MARK: Action
    @IBAction func tappedEditButton(sender: UIButton) {
        tableView.setEditing(!tableView.editing, animated: true)
        if sender.currentTitle == "edit".localized() {
            sender.setTitle("done".localized(), forState: .Normal)
        } else {
            sender.setTitle("edit".localized(), forState: .Normal)
        }
    }
    
    private func fetchSummary() {
        NetworkActivityManager.increaseActivityCount()
        dataSource.fetchData({ [unowned self] () -> Void in
                self.updateDataInView()
                NetworkActivityManager.decreaseActivityCount()
            }) { (error) -> Void in
                NetworkActivityManager.decreaseActivityCount()
        }
    }
    
    private func updateDataInView() {
        if let summary = dataSource.summary {
            let summaryViewModel = SummaryViewModel(summary: summary)
            availableLabel.text = summaryViewModel.availableString
            usedLabel.text = summaryViewModel.usedString
            updateTimeLabel.text = "Updated: ".localized() + summaryViewModel.updateTimeString
        }
        tableView.reloadData()
    }
    
    // MARK: Table view delegate
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}
