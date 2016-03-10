//
//  TodayExtensionOrderTableViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 10..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class TodayExtensionOrderTableViewController: UITableViewController {
    var orderedLibraryIds: [Int]!
    var hiddenLibraryIds: [Int]!
    var libraryInformation: [Library]!
    
    // MARK: Setup
    private func initialSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.editing = true
        
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        let libraryDicts = defaults.arrayForKey("libraryInformation") as! [NSDictionary]
        let libraries = libraryDicts.map({ Library(dictionary: $0)! })
        
        orderedLibraryIds = defaults.arrayForKey("todayExtensionOrder") as! [Int]
        hiddenLibraryIds = defaults.arrayForKey("todayExtensionHidden") as! [Int]
        libraryInformation = libraries
    }
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
}

// MARK: Data source
extension TodayExtensionOrderTableViewController {
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Show"
        case 1: return "Hide"
        default: return ""
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1: return "View dragged here will be hidden in notificaiton center."
        default: return ""
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return orderedLibraryIds?.count ?? 0
        case 1: return hiddenLibraryIds?.count ?? 0
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let libraryId: Int
        switch indexPath.section {
        case 0: libraryId = orderedLibraryIds[indexPath.row]
        case 1: libraryId = hiddenLibraryIds[indexPath.row]
        default: return cell
        }
        let library = libraryInformation.filter({ $0.id == libraryId }).first
        cell.textLabel?.text = library?.name
        return cell
    }
}

// MARK: Move
extension TodayExtensionOrderTableViewController {
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let fromSection = sourceIndexPath.section
        let fromRow = sourceIndexPath.row
        let toSection = destinationIndexPath.section
        let toRow = destinationIndexPath.row
        
        let movingLibraryId: Int
        if fromSection == 0 {
            movingLibraryId = orderedLibraryIds[fromRow]
            orderedLibraryIds.removeAtIndex(fromRow)
        } else {
            movingLibraryId = hiddenLibraryIds[fromRow]
            hiddenLibraryIds.removeAtIndex(fromRow)
        }
        
        if toSection == 0 {
            orderedLibraryIds.insert(movingLibraryId, atIndex: toRow)
        } else {
            hiddenLibraryIds.insert(movingLibraryId, atIndex: toRow)
        }
        
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        defaults.setValue(orderedLibraryIds, forKey: "todayExtensionOrder")
        defaults.setValue(hiddenLibraryIds, forKey: "todayExtensionHidden")
        defaults.synchronize()
    }
}
