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

enum DataSourceState {
    case Fetching, Error
}

class SummaryViewController: UIViewController, UIViewControllerPreviewingDelegate {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    private  var refreshControl = UIRefreshControl()
    
    private var libraryDataArray = [LibraryData]()
    private var dataState: DataSourceState = .Fetching
    private var error: NSError?
    
    private var orderedLibraryIds: [String]!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setTransparentNavigationBar() // Transparent navigation bar
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updateData(_:)), forControlEvents: .ValueChanged)
        registerPeekAndPop()
        listenForUserDefaultsDidChange()
        updateData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startHandoff()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        userActivity?.invalidate()
    }
    
    // MARK: Action
    @objc private func updateData(sender: UIRefreshControl? = nil) {
        dataState = .Fetching
        NetworkActivityManager.increaseActivityCount()
        libraryDataArray.removeAll(keepCapacity: true)
        kuStudy.requestAllLibraryData(onLibrarySuccess: { [weak self] (libraryData) in
            self?.libraryDataArray.append(libraryData)
        }, onFailure: { [weak self] (error) in
            self?.error = error
            self?.dataState = .Error
        }) { [weak self] (summaryData: SummaryData) in
            sender?.endRefreshing()
            self?.reorderLibraryData()
            self?.updateView()
            NetworkActivityManager.decreaseActivityCount()
        }
    }
    
    private func updateView() {
        if let libraryData = libraryDataArray.filter({ $0.libraryId == LibraryType.CentralSquare.rawValue }).first {
            headerImageView.image = libraryData.photo?.image
        }
        tableView.reloadData()
    }
    
    private func reorderLibraryData() {
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        orderedLibraryIds = defaults.arrayForKey("libraryOrder") as! [String]
        
        var orderedLibraryData = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = self.libraryDataArray.filter({ $0.libraryId! == libraryId }).first else { continue }
            orderedLibraryData.append(libraryData)
        }
        libraryDataArray = orderedLibraryData
    }
}

// MARK: Navigation
extension SummaryViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "librarySegue":
            let destinationViewController = segue.destinationViewController as! LibraryViewController
            if sender is String { // Handoff
                let libraryId = sender as! String
                destinationViewController.libraryId = libraryId
            } else {
                guard let selectedRow = tableView.indexPathForSelectedRow?.row else { return }
                let libraryData = libraryDataArray[selectedRow]
                destinationViewController.libraryId = libraryData.libraryId
            }
        default: break
        }
    }
}

// MARK:
// MARK: Table view
extension SummaryViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    // Data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let libraryData = libraryDataArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("libraryCell", forIndexPath: indexPath) as! LibraryTableViewCell
        cell.populate(libraryData)
        return cell
    }
    
    // MARK: Empty state
    func emptyDataSetDidTapView(scrollView: UIScrollView!) {
        updateData()
        updateView()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = dataState == .Fetching ? "Fetching data...".localized() : (error?.localizedDescription ?? "An error occurred.".localized())
        let attribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(17)]
        return NSAttributedString(string: text, attributes: attribute)
    }
}

// MARK:
// MARK: Notification
extension SummaryViewController {
    private func listenForUserDefaultsDidChange() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleUserDefaultsDidChange(_: )), name: NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    @objc private func handleUserDefaultsDidChange(notification: NSNotification) {
        reorderLibraryData()
        updateView()
    }
}

// MARK:
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
        let libraryData = libraryDataArray[indexPath.row]
        libraryViewController.libraryId = libraryData.libraryId
        return libraryViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}
