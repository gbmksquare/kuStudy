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
    var libraryData: LibraryData!
    
    // MARK: Watch
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        libraryData = context as! LibraryData
        updateView()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        updateData()
        startHandoff()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        invalidateUserActivity()
    }
    
    // MARK: Action
    @IBAction func tappedRefreshMenu() {
        updateData()
        updateView()
    }
    
    fileprivate func updateData() {
        guard let libraryId = libraryData.libraryId else { return }
        kuStudy.requestLibraryData(libraryId: libraryId,
           onSuccess: { [weak self](libraryData) in
            self?.updateView()
        }) { [weak self] (error) in
            self?.updateView()
        }
    }
    
    fileprivate func updateView() {
        guard let libraryId = libraryData.libraryId else { return }
        let libraryType = LibraryType(rawValue: libraryId)
        setTitle(libraryType?.name)
        totalLabel.setText(libraryData.totalSeats.readable)
        usedLabel.setText(libraryData.usedSeats.readable)
        availableLabel.setText(libraryData.availableSeats.readable)
        availableLabel.setTextColor(libraryData.usedPercentageColor)
        percentageGroup.startAnimatingWithImages(in:
            NSRange(location: 0, length: Int(libraryData.usedPercentage * 100)),
            duration: 1, repeatCount: 1)
        
        // Refresh table
        guard let sectors = libraryData.sectors else { return }
        table.setNumberOfRows(sectors.count, withRowType: "readingRoomCell")
        for (index, sectorData) in sectors.enumerated() {
            let row = table.rowController(at: index) as! ReadingRoomCell
            row.populate(sectorData)
        }
    }
}

// MARK:
// MARK: Handoff
extension DetailInterfaceController {
    fileprivate func startHandoff() {
        guard let libraryId = libraryData.libraryId else { return }
        updateUserActivity(kuStudyHandoffLibrary, userInfo: [kuStudyHandoffLibraryIdKey: libraryId], webpageURL: nil)
    }
}
