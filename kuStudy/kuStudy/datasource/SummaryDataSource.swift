//
//  SummaryDataSource.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 2. 4..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import DZNEmptyDataSet

class SummaryDataSource: NSObject, UITableViewDataSource, DZNEmptyDataSetSource {
    var summary: Summary?
    var libraries = [Library]()
    lazy var orderedLibraryIds = NSUserDefaults(suiteName: kuStudySharedContainer)?.arrayForKey("libraryOrder") as? [Int] ?? NSUserDefaults.standardUserDefaults().arrayForKey("libraryOrder") as! [Int]
    
    // MARK: Action
    func fetchData(success: () -> Void, failure: (error: NSError) -> Void) {
        kuStudy.requestSeatSummary({ [unowned self] (summary, libraries) -> Void in
                self.summary = summary
                self.libraries = libraries
                success()
            }) { (error) -> Void in
                failure(error: error)
        }
    }
    
    // MARK: Empty state
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Data"
        let attribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(17)]
        return NSAttributedString(string: text, attributes: attribute)
    }
    
    // MARK: Data source
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
    
    // MARK: Move
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
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
