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
    
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    
    // MARK: Model
    private var summary: Summary?
    private var libraries = [Library]()
    private lazy var orderedLibraryIds = NSUserDefaults(suiteName: kuStudySharedContainer)?.arrayForKey("libraryOrder") as? [Int] ?? NSUserDefaults.standardUserDefaults().arrayForKey("libraryOrder") as! [Int]
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
    
    // MARK: Setup
    private func setupView() {
        navigationController?.setTransparentNavigationBar() // Transparent navigation bar
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
                let selectedRow = tableView.indexPathForSelectedRow!.row
                destinationViewController.libraryId = orderedLibraryIds[selectedRow]
            default: break
            }
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
    
    // MARK: Action
    @IBAction func tappedEditButton(sender: UIButton) {
        tableView.setEditing(!tableView.editing, animated: true)
        if sender.currentTitle == "edit" {
            sender.setTitle("done", forState: .Normal)
        } else {
            sender.setTitle("edit", forState: .Normal)
        }
    }
    
    private func fetchData() {
        NetworkActivityManager.increaseActivityCount()
        kuStudy.requestSeatSummary({ [unowned self] (summary, libraries) -> Void in
                self.summary = summary
                self.libraries = libraries
                self.updateDataInView()
            NetworkActivityManager.decreaseActivityCount()
            }) { (error) -> Void in
                NetworkActivityManager.decreaseActivityCount()
        }
    }
    
    private func updateDataInView() {
        if let summary = summary {
            let summaryViewModel = SummaryViewModel(summary: summary)
            availableLabel.text = summaryViewModel.availableString
            usedLabel.text = summaryViewModel.usedString
        }
        tableView.reloadData()
    }
    
    // MARK: Table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard libraries.count > 0 else { return 0 }
        return orderedLibraryIds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("libraryCell", forIndexPath: indexPath) as! LibraryTableViewCell
        let libraryId = orderedLibraryIds[indexPath.row]
        let library = libraries[libraryId - 1]
        let libraryViewModel = LibraryViewModel(library: library)
        cell.populate(libraryViewModel)
        return cell
    }
    
    // MARK: Table view reorder
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let fromRow = sourceIndexPath.row
        let toRow = destinationIndexPath.row
        let moveLibraryId = orderedLibraryIds[fromRow]
        orderedLibraryIds.removeAtIndex(fromRow)
        orderedLibraryIds.insert(moveLibraryId, atIndex: toRow)
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        defaults.setValue(orderedLibraryIds, forKey: "libraryOrder")
        defaults.synchronize()
    }
}
