//
//  TodayViewController.swift
//  kuStudy Today Extension
//
//  Created by 구범모 on 2015. 6. 6..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import NotificationCenter
import kuStudyKit

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var liberalArtCampusLabel: UILabel!
    @IBOutlet weak var scienceCampusLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    private var isExtended = false
    
    // MARK: Model
    var summary: Summary?
    var libraries = [Library]()
    
    private let liberalArtCampusIds = [1, 2, 5]
    private let scienceCampusIds = [3, 4]
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
    }
    
    // MARK: Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        updateTableViewHeight()
    }
    
    // MARK: Action
    @IBAction func tappedExtendButton(sender: UIButton) {
        isExtended = !isExtended
        updateTableViewHeight()
    }
    
    private func fetchData() {
        kuStudy.requestSeatSummary({ [weak self] (summary, libraries) -> Void in
                self?.summary = summary
                self?.libraries = libraries
                self?.updateDataInView()
            }) { (error) -> Void in
                
        }
    }
    
    private func updateDataInView() {
        // Summary
        var liberalArtsCampusAvailable = 0
        var scienceCampusAvailable = 0
        for library in libraries {
            if liberalArtCampusIds.contains(library.id) {
                liberalArtsCampusAvailable += library.available
            } else if scienceCampusIds.contains(library.id) {
                scienceCampusAvailable += library.available
            }
        }
        liberalArtCampusLabel.text = String(liberalArtsCampusAvailable)
        scienceCampusLabel.text = String(scienceCampusAvailable)
        
        tableView.reloadData()
    }
    
    private func updateTableViewHeight() {
        if isExtended == true {
            tableViewHeightConstraint.constant = CGFloat(libraries.count * 44)
        } else {
            tableViewHeightConstraint.constant = 0
        }
    }
    
    // MARK: Table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("libraryCell", forIndexPath: indexPath) as! LibraryCell
        let library = libraries[indexPath.row]
        let libraryViewModel = LibraryViewModel(library: library)
        cell.populate(libraryViewModel)
        return cell
    }
    
    // MARK: Widget
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        fetchData()
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var newMargins = defaultMarginInsets
        newMargins.bottom = 0
        return newMargins
    }
}
