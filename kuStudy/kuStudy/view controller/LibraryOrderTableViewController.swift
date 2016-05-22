//
//  LibraryOrderTableViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 8..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryOrderTableViewController: UITableViewController {
    private var defaults: NSUserDefaults!
    private var libraryTypes: [LibraryType]!
    private var orderedLibraryIds: [String]!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        orderedLibraryIds = defaults.arrayForKey("libraryOrder") as! [String]
        libraryTypes = LibraryType.allTypes()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.editing = true
    }
}

// MARK: Data source
extension LibraryOrderTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedLibraryIds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let libraryId = orderedLibraryIds[indexPath.row]
        let libraryType = libraryTypes.filter({ $0.rawValue == libraryId }).first!
        cell.textLabel?.text = libraryType.name
        return cell
    }
}

// MARK: Move
extension LibraryOrderTableViewController {
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
        let fromRow = sourceIndexPath.row
        let toRow = destinationIndexPath.row
        let moveLibraryId = orderedLibraryIds[fromRow]
        orderedLibraryIds.removeAtIndex(fromRow)
        orderedLibraryIds.insert(moveLibraryId, atIndex: toRow)
        
        defaults.setValue(orderedLibraryIds, forKey: "libraryOrder")
        defaults.synchronize()
    }
}
