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
import Localize_Swift

enum DataSourceState {
    case Fetching, Error
}

class SummaryDataSource: NSObject, UITableViewDataSource, DZNEmptyDataSetSource {
    var summary: Summary?
    var libraries = [Library]()
    var orderedLibraryIds: [Int]!
    
    private var dataState: DataSourceState = .Fetching
    private var error: NSError?
    
    // MARK: Initialization
    override init() {
        super.init()
        updateLibraryOrder()
    }
    
    // MARK: Action
    func updateLibraryOrder() {
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        orderedLibraryIds = defaults.arrayForKey("libraryOrder") as! [Int]
    }
    
    func fetchData(success: () -> Void, failure: (error: NSError) -> Void) {
        dataState = .Fetching
        kuStudy.requestSeatSummary(
            { [weak self] (summary, libraries) -> Void in
                self?.handleFetchedData(summary, libraries: libraries, success: success)
            }) { [weak self] (error) -> Void in
                self?.dataState = .Error
                self?.error = error
                failure(error: error)
        }
    }
    
    private func handleFetchedData(summary: Summary, libraries: [Library], success: () -> Void) {
        self.summary = summary
        self.libraries = libraries
        success()
    }
}

// MARK: Data source
extension SummaryDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard libraries.count > 0 else { return 0 }
        return orderedLibraryIds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let libraryId = orderedLibraryIds[indexPath.row]
        let library = libraries.filter({ $0.id == libraryId }).first
        let cell = tableView.dequeueReusableCellWithIdentifier("libraryCell", forIndexPath: indexPath) as! LibraryTableViewCell
        if let library = library {
            cell.populate(library)
        } else {
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
        }
        return cell
    }
    
    // MARK: Empty state
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = dataState == .Fetching ? "Fetching data...".localized() : (error?.localizedDescription ?? "An error occurred.".localized())
        let attribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(17)]
        return NSAttributedString(string: text, attributes: attribute)
    }
}

// MARK: Move
extension SummaryDataSource {
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
