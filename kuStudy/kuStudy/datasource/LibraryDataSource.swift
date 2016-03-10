//
//  LibraryDataSource.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 2. 4..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation
import kuStudyKit
import DZNEmptyDataSet
import Localize_Swift

class LibraryDataSource: NSObject, UITableViewDataSource, DZNEmptyDataSetSource {
    var library: Library?
    var readingRooms = [ReadingRoom]()
    
    private var dataState: DataSourceState = .Fetching
    private var error: NSError?
    
    // MARK: Action
    func fetchData(id: Int, success: () -> Void, failure: (error: NSError) -> Void) {
        dataState = .Fetching
        kuStudy.requestLibrarySeatSummary(id,
            success: { [weak self] (library, readingRooms) -> Void in
                self?.library = library
                self?.readingRooms = readingRooms
                success()
            }) { [weak self] (error) -> Void in
                self?.dataState = .Error
                self?.error = error
                failure(error: error)
        }
    }
    
    // MARK: Empty state
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = dataState == .Fetching ? "Fetching data...".localized() : (error?.localizedDescription ?? "An error occurred.".localized())
        let attribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(17)]
        return NSAttributedString(string: text, attributes: attribute)
    }
    
    // MARK: Data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingRooms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("readingRoomCell", forIndexPath: indexPath) as! ReadingRoomTableViewCell
        let readingRoom = readingRooms[indexPath.row]
        cell.populate(readingRoom)
        return cell
    }
}
