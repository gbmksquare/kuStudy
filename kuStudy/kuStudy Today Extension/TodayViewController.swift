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
import SwiftyJSON

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Model
    var summary: Summary?
    var libraries = [Library]()
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    private func updateView() {
        // Summary
        if let summary = summary {
            let summaryViewModel = SummaryViewModel(summary: summary)
            totalLabel.text = summaryViewModel.totalString
            availableLabel.text = summaryViewModel.availableString
        }
        
        // Table view
        tableViewHeight.constant = CGFloat(libraries.count) * 55
        tableView.reloadData()
    }
    
    // MARK: Action
    private func refreshData() {
        kuStudy().setAuthentification(kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
        kuStudy().requestSummary { (json, error) -> Void in
            if let json = json {
                // Summary
                let total = json["content"]["total"].intValue
                let available = json["content"]["available"].intValue
                self.summary = Summary(total: total, available: available)
                
                // Libraries
                self.libraries = [Library]()
                let libraries = json["content"]["libraries"].arrayValue
                for library in libraries {
                    let id = library["id"].intValue
                    let total = library["total"].intValue
                    let available = library["available"].intValue
                    let library = Library(id: id, total: total, available: available)
                    self.libraries.append(library)
                }
                self.updateView()
            } else {
                // TODO: Handle error
            }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("libraryCell", forIndexPath: indexPath) as! LibraryTableViewCell
        let library = libraries[indexPath.row]
        let libraryViewModel = LibraryViewModel(library: library)
        
        cell.nameLabel.text = libraryViewModel.name
        cell.totalLabel.text = libraryViewModel.totalString
        cell.availableLabel.text = libraryViewModel.availableString
        return cell
    }
    
    // MARK: Widget
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        refreshData()
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var newMargins = defaultMarginInsets
        newMargins.bottom = 0
        return newMargins
    }
}
