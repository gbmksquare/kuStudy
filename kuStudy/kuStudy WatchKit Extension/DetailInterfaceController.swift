//
//  DetailInterfaceController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 1..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import WatchKit
import kuStudyWatchKit

class DetailInterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var totalLabel: WKInterfaceLabel!
    @IBOutlet weak var usedLabel: WKInterfaceLabel!
    @IBOutlet weak var availableLabel: WKInterfaceLabel!
    @IBOutlet weak var percentageGroup: WKInterfaceGroup!
    
    // MARK: Model
    var libraryId: Int!
    private var library: Library?
    private var readingRooms = [ReadingRoom]()
    
    // MARK: Watch
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        libraryId = (context as! [Int]).first!
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        fetchData()
        
        // Handoff
        updateUserActivity(kuStudyHandoffLibrary, userInfo: [kuStudyHandoffLibraryIdKey: libraryId], webpageURL: nil)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: Action
    private func fetchData() {
        kuStudy.requestLibrarySeatSummary(libraryId,
            success: { [weak self] (library, readingRooms) -> Void in
                self?.library = library
                self?.readingRooms = readingRooms
                self?.updateDataInView()
            }) { (error) -> Void in
                
        }
    }
    
    private func updateDataInView() {
        if let library = library {
            totalLabel.setText(library.totalString)
            usedLabel.setText(library.usedString)
            availableLabel.setText(library.availableString)
            availableLabel.setTextColor(library.usedPercentageColor)
            percentageGroup.startAnimatingWithImagesInRange(
                NSRange(location: 0, length: Int(library.usedPercentage * 100)),
                duration: 1, repeatCount: 1)
        }
        
        // Refresh table
        table.setNumberOfRows(readingRooms.count, withRowType: "readingRoomCell")
        for index in 0 ..< readingRooms.count {
            let readingRoom = readingRooms[index]
            let row = table.rowControllerAtIndex(index) as! ReadingRoomCell
            row.populate(readingRoom)
        }
    }
}
