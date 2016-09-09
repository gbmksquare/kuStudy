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
    @IBOutlet weak var headerBlurImageView: UIImageView!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private  var refreshControl = UIRefreshControl()
    
    private var summaryData = SummaryData()
    private var dataState: DataSourceState = .Fetching
    private var error: NSError?
    
    private var orderedLibraryIds: [String]!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
        navigationController?.setTransparentNavigationBar() // Transparent navigation bar
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
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
        updateHeaderImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        userActivity?.invalidate()
    }
    
    // MARK: Action
    @objc private func updateData(sender: UIRefreshControl? = nil) {
        dataState = .Fetching
        kuStudy.requestSummaryData(onLibrarySuccess: { (libraryData) in
            
        }, onFailure: { [weak self] (error) in
            self?.error = error
            self?.dataState = .Error
        }) { [weak self] (summaryData: SummaryData) in
            sender?.endRefreshing()
            self?.summaryData = summaryData
            self?.reorderLibraryData()
            self?.updateView()
        }
    }
    
    private func setInitialView() {
        studyingLabel.text = ""
    }
    
    private func updateView() {
        if let usedSeats = summaryData.usedSeats {
            studyingLabel.text = usedSeats.readableFormat + "kuStudy.Main.Studying".localized()
        }
        tableView.reloadData()
    }
    
    private func updateHeaderImage() {
        let libraryTypes = LibraryType.allTypes()
        let randomIndex = Int(arc4random_uniform(UInt32(libraryTypes.count)))
        let libraryId = libraryTypes[randomIndex].rawValue
        if let libraryType = LibraryType(rawValue: libraryId) {
            let photo = PhotoProvider.sharedProvider.photo(libraryType.rawValue)
            headerImageView.image = photo.image
            headerBlurImageView.image = photo.image
            headerBlurImageView.transform = CGAffineTransformMakeScale(1, -1)
        }
    }
    
    private func reorderLibraryData() {
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        orderedLibraryIds = defaults.arrayForKey("libraryOrder") as! [String]
        
        var orderedLibraryData = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = summaryData.libraries.filter({ $0.libraryId! == libraryId }).first else { continue }
            orderedLibraryData.append(libraryData)
        }
        summaryData.libraries = orderedLibraryData
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
                let libraryData = summaryData.libraries[selectedRow]
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
        return summaryData.libraries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let libraryData = summaryData.libraries[indexPath.row]
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
        let text = dataState == .Fetching ? "kuStudy.Status.Downloading".localized() : (error?.localizedDescription ?? "kuStudy.Status.Error".localized())
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
        let libraryData = summaryData.libraries[indexPath.row]
        libraryViewController.libraryId = libraryData.libraryId
        previewingContext.sourceRect = view.convertRect(tableView.rectForRowAtIndexPath(indexPath), fromView: tableView)
        return libraryViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}
