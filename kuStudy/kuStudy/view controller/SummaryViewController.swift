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

class SummaryViewController: UIViewController, UITableViewDelegate, DZNEmptyDataSetDelegate, UIViewControllerPreviewingDelegate {
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    
    lazy var dataSource = SummaryDataSource()
    private  var refreshControl = UIRefreshControl()
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        registerPeekAndPop()
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
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = dataSource
        tableView.tableFooterView = UIView()
//        tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
//        tableView.estimatedRowHeight = 60
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "fetchSummary:", forControlEvents: .ValueChanged)
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
    
    
    // MARK: Action
    @IBAction func tappedEditButton(sender: UIButton) {
        tableView.setEditing(!tableView.editing, animated: true)
        if sender.currentTitle == "edit".localized() {
            sender.setTitle("done".localized(), forState: .Normal)
        } else {
            sender.setTitle("edit".localized(), forState: .Normal)
        }
    }
    
    @objc private func fetchSummary(sender: UIRefreshControl? = nil) {
        NetworkActivityManager.increaseActivityCount()
        dataSource.fetchData({ [unowned self] () -> Void in
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
        if let summary = dataSource.summary {
            availableLabel.text = summary.availableString
            usedLabel.text = summary.usedString
            updateTimeLabel.text = "Updated: ".localized() + summary.updatedTimeString
        }
        tableView.reloadData()
    }
    
    // MARK: Table view
    func emptyDataSetDidTapView(scrollView: UIScrollView!) {
        fetchSummary()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

// MARK: Navigation
extension SummaryViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "librarySegue":
                let destinationViewController = segue.destinationViewController as! LibraryViewController
                let selectedRow = tableView.indexPathForSelectedRow!.row
                let libraryId = dataSource.orderedLibraryIds[selectedRow]
                destinationViewController.libraryId = libraryId
            default: break
            }
        }
    }
}

// MARK: Handoff
extension SummaryViewController {
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
}

// MARK: Peek & Pop
extension SummaryViewController {
    private func registerPeekAndPop() {
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let locationInTableView = tableView.convertPoint(location, fromView: view)
        guard let indexPath = tableView.indexPathForRowAtPoint(locationInTableView) else { return nil }
        let libraryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("libraryViewController") as! LibraryViewController
        libraryViewController.libraryId = dataSource.orderedLibraryIds[indexPath.row]
        return libraryViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}
