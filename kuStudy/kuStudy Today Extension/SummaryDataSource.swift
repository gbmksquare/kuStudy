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
    case Fetching, Error
}

class SummaryDataSource: NSObject, UITableViewDataSource {
    var summary: Summary?
    var libraries = [Library]()
    
    private var dataState: DataSourceState = .Fetching
    private var error: NSError?
}

// MARK: Action
extension SummaryDataSource {
    func fetchData(success: () -> Void, failure: (error: NSError) -> Void) {
        dataState = .Fetching
        kuStudy.requestSeatSummary(
            { [unowned self] (summary, libraries) -> Void in
                self.handleFetchedData(summary, libraries: libraries, success: success)
            }) { [unowned self] (error) -> Void in
                self.dataState = .Error
                self.error = error
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
        return libraries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let library = libraries[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("libraryCell", forIndexPath: indexPath) as! LibraryTableViewCell
        cell.populate(library)
        return cell
    }
}
