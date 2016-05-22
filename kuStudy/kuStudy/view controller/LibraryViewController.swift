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

class LibraryViewController: UIViewController {
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var libraryNameLabel: UILabel!
    
    var libraryId: String!
    private var libraryData: LibraryData?
    
    private var dataState: DataSourceState = .Fetching
    private var error: NSError?
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryNameLabel.text = ""
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updateData(_:)), forControlEvents: .ValueChanged)
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
        guard let libraryId = self.libraryId else { return }
        NetworkActivityManager.increaseActivityCount()
        kuStudy.requestLibraryData(libraryId: libraryId,
           onSuccess: { [weak self] (libraryData) in
            self?.libraryData = libraryData
            sender?.endRefreshing()
            NetworkActivityManager.decreaseActivityCount()
            self?.updateView()
        }) { [weak self] (error) in
            self?.dataState = .Error
            self?.error = error
            self?.updateView()
            sender?.endRefreshing()
            NetworkActivityManager.decreaseActivityCount()
        }
    }
    
    private func updateView() {
        headerImageView.image = libraryData?.photo?.image
        tableView.reloadData()
    }
}

// MARK:
// MARK: Table view
extension LibraryViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    // Data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryData?.sectorCount ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sector = libraryData?.sectors?[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("readingRoomCell", forIndexPath: indexPath) as! ReadingRoomTableViewCell
        if let sector = sector {
            cell.populate(sector)
        }
        return cell
    }
    
    // Empty state
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

// MARK: Handoff
extension LibraryViewController {
    // MARK: Handoff
    private func startHandoff() {
        guard let libraryId = self.libraryId, name = LibraryType(rawValue: libraryId)?.name else { return }
        let activity = NSUserActivity(activityType: kuStudyHandoffLibrary)
        activity.title = name
        activity.addUserInfoEntriesFromDictionary(["libraryId": libraryId])
        activity.becomeCurrent()
        userActivity = activity
    }
}
