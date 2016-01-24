//
//  SummaryViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    
    // MARK: Model
    var summary: Summary?
    var libraries = [Library]()
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }
    
    private func setupView() {
        // Table view insets
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        
        // Transparent navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        navigationController?.view.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        
        // Graident
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = summaryView.bounds
        gradientLayer.colors = [UIColor(red: 48/255, green: 35/255, blue: 174/255, alpha: 1).CGColor,
            UIColor(red: 109/255, green: 170/255, blue: 215/255, alpha: 1).CGColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        summaryView.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    private func updateView() {
        // Summary
        if let summary = summary {
            let summaryViewModel = SummaryViewModel(summary: summary)
            totalLabel.text = summaryViewModel.totalString
            availableLabel.text = summaryViewModel.availableString
        }
        
        // Table
        tableView.reloadData()
    }
    
    // MARK: Action
    private func refreshData() {
        kuStudy.requestSeatSummary({ (summary, libraries) -> Void in
                self.summary = summary
                self.libraries = libraries
                self.updateView()
            }) { (error) -> Void in
                
        }
    }
    
    // MARK: Handoff
    override func restoreUserActivityState(activity: NSUserActivity) {
        switch activity.activityType {
        case kuStudyHandoffSummary: break
//        case kuStudyHandoffLibrary:
            // TODO: Pass to libraryViewController
        default: break
        }
        super.restoreUserActivityState(activity)
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "librarySegue":
                let destinationViewController = segue.destinationViewController as! LibraryViewController
                destinationViewController.libraryId = tableView.indexPathForSelectedRow!.row + 1
            default: break
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
        cell.usedPercentage.progress = libraryViewModel.usedPercentage
        cell.usedPercentage.tintColor = libraryViewModel.usedPercentageColor
        
        return cell
    }
}
