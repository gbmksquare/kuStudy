//
//  LibraryDataSource.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 2. 4..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation
import kuStudyKit

class LibraryDataSource: NSObject, UITableViewDataSource {
    var library: Library?
    var readingRooms = [ReadingRoom]()
    
    // MARK: Action
    func fetchData(id: Int, success: () -> Void, failure: (error: NSError) -> Void) {
        kuStudy.requestLibrarySeatSummary(id,
            success: { [unowned self] (library, readingRooms) -> Void in
                self.library = library
                self.readingRooms = readingRooms
                success()
            }) { (error) -> Void in
                failure(error: error)
        }
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
        let readingRoomViewModel = ReadingRoomViewModel(library: readingRoom)
        cell.populate(readingRoomViewModel)
        return cell
    }
}
