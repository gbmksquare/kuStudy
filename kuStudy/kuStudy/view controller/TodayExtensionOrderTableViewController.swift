//
//  TodayExtensionOrderTableViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 10..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import Localize_Swift

class TodayExtensionOrderTableViewController: UITableViewController {
    private var defaults: NSUserDefaults!
    private var libraryTypes: [LibraryType]!
    private var orderedLibraryIds: [String]!
    private var hiddenLibraryIds: [String]!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        orderedLibraryIds = defaults.arrayForKey("todayExtensionOrder") as! [String]
        hiddenLibraryIds = defaults.arrayForKey("todayExtensionHidden") as! [String]
        libraryTypes = LibraryType.allTypes()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.editing = true
    }
}

// MARK: Data source
extension TodayExtensionOrderTableViewController {
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "kuStudy.Settings.Today.Header.Show".localized()
        case 1: return "kuStudy.Settings.Today.Header.Hide".localized()
        default: return nil
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0: return "kuStudy.Settings.Today.Footer.Instruction".localized()
        case 1: return "kuStudy.Settings.Today.Footer.Hidden".localized()
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
        let libraryId: String
        switch indexPath.section {
        case 0: libraryId = orderedLibraryIds[indexPath.row]
        case 1: libraryId = hiddenLibraryIds[indexPath.row]
        default: return cell
        }
        let libraryType = libraryTypes.filter({ $0.rawValue == libraryId }).first!
        cell.textLabel?.text = libraryType.name
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
        
        let movingLibraryId: String
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
        
        defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        defaults.setValue(orderedLibraryIds, forKey: "todayExtensionOrder")
        defaults.setValue(hiddenLibraryIds, forKey: "todayExtensionHidden")
        defaults.synchronize()
    }
}
