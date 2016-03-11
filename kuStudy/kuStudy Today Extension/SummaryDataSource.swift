//
//  SummaryDataSource.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 9..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

enum DataSourceState {
    case Fetching, Loaded, Error
}

class SummaryDataSource: NSObject, UITableViewDataSource {
    var summary: Summary?
    var libraries = [Library]()
    
    var orderedLibraryIds: [Int]!
    
    var dataState: DataSourceState = .Fetching
    private var error: NSError?
    
    // MARK: Initialization
    override init() {
        super.init()
        updateLibraryOrder()
    }
    
    // MARK: Action
    func updateLibraryOrder() {
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        orderedLibraryIds = defaults.arrayForKey("todayExtensionOrder") as! [Int]
    }
}

// MARK: Action
extension SummaryDataSource {
    func fetchData(success: () -> Void, failure: (error: NSError) -> Void) {
        dataState = .Fetching
        kuStudy.requestSeatSummary(
            { [weak self] (summary, libraries) -> Void in
                self?.dataState = .Loaded
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
        }
        return cell
    }
}