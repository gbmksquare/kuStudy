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
    @IBOutlet weak var shadowView: ShadowGradientView!
    @IBOutlet weak var libraryImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    
    private  var refreshControl = UIRefreshControl()
    lazy var dataSource = SummaryDataSource()
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
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
        shadowView.updateGradientLayout()
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
                self.reloadData()
                self.populateHeader()
                sender?.endRefreshing()
                NetworkActivityManager.decreaseActivityCount()
            }) { [unowned self] (error) -> Void in
                self.tableView.reloadData()
                sender?.endRefreshing()
                NetworkActivityManager.decreaseActivityCount()
        }
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

// MARK: Setup
extension SummaryViewController {
    // MARK: Setup
    private func initialSetup() {
        navigationController?.setTransparentNavigationBar() // Transparent navigation bar
        setupTableView()
        registerPeekAndPop()
        listenForUserDefaultsDidChange()
    }
    
    private func populateHeader() {
        libraryImageView.image = dataSource.summary?.photo?.image
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = dataSource
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "fetchSummary:", forControlEvents: .ValueChanged)
    }
    
    private func listenForUserDefaultsDidChange() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleUserDefaultsDidChange:"), name: NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    @objc private func handleUserDefaultsDidChange(notification: NSNotification) {
        dataSource.updateLibraryOrder()
        tableView.reloadData()
    }
}

// MARK: Data
extension SummaryViewController {
    private func reloadData() {
        if let summary = dataSource.summary {
            availableLabel.text = summary.availableString
            usedLabel.text = summary.usedString
            updateTimeLabel.text = "Updated: ".localized() + summary.updatedTimeString
        }
        tableView.reloadData()
    }
}

// MARK: Navigation
extension SummaryViewController {
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
                let library = dataSource.libraries[libraryId - 1]
                destinationViewController.passedLibrary = library
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
        let libraryId = dataSource.orderedLibraryIds[indexPath.row]
        let library = dataSource.libraries[libraryId - 1]
        libraryViewController.passedLibrary = library
        return libraryViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}
