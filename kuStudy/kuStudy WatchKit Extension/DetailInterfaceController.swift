//
//  DetailInterfaceController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 1..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import WatchKit
import kuStudyKit
import SwiftyJSON

class DetailInterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    
    
    // MARK: Model
    var libraryId: Int!
    var readingRooms = [ReadingRoom]()
    
    // MARK: Table
    private func refreshData() {
        // Refresh table
        table.setNumberOfRows(readingRooms.count, withRowType: "readingRoomCell")
        for index in 0 ..< readingRooms.count {
            let readingRoom = readingRooms[index]
            let readingRoomViewModel = LibraryViewModel(library: readingRoom)
            let row = table.rowControllerAtIndex(index) as! LibraryCell
            row.nameLabel.setText(readingRoomViewModel.name)
            row.availableLabel.setText(readingRoomViewModel.availableString)
        }
    }
    
    // MARK: Watch
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        libraryId = (context as! [Int]).first!
        
        WKInterfaceController.openParentApplication([kuStudyWatchKitRequestKey: kuStudyWatchKitRequestLibrary, kuStudyWatchKitRequestLibraryKey: libraryId],
            reply: { (replyInfo, error) -> Void in
                if let libraryDict = replyInfo[kuStudyWatchKitRequestLibrary] as? NSDictionary {
                    let json = JSON(libraryDict)
                    
                    let readingRooms = json["content"]["rooms"].arrayValue
                    for readingRoom in readingRooms {
                        let id = readingRoom["id"].intValue
                        let total = readingRoom["total"].intValue
                        let available = readingRoom["available"].intValue
                        let readingRoom = ReadingRoom(id: id, total: total, available: available)
                        self.readingRooms.append(readingRoom)
                    }
                    self.refreshData()
                } else {
                    // TODO: Handle error
                }
        })
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // Handoff
        updateUserActivity(kuStudyHandoffLibrary, userInfo: [kuStudyHandoffLibraryIdKey: libraryId], webpageURL: nil)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
