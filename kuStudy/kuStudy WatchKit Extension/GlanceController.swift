//
//  GlanceController.swift
//  kuStudy WatchKit Extension
//
//  Created by 구범모 on 2015. 6. 1..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import WatchKit
import Foundation
import kuStudyWatchKit

class GlanceController: WKInterfaceController {
    @IBOutlet weak var availableLabel: WKInterfaceLabel!
    @IBOutlet weak var percentageLabel: WKInterfaceLabel!
    @IBOutlet weak var percentageGroup: WKInterfaceGroup!
    
    @IBOutlet weak var liberalArtCampusLabel: WKInterfaceLabel!
    @IBOutlet weak var scienceCampusLabel: WKInterfaceLabel!
    
    // MARK: Model
    private var summaryData = SummaryData()
    
    private var liberalArtCampusIds = [String]()
    private var scienceCampusIds = [String]()
    
    // MARK: Watch
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        liberalArtCampusIds = [LibraryType.CentralLibrary, LibraryType.CentralSquare, LibraryType.CDL].map({ "\($0.rawValue)" })
        scienceCampusIds = [LibraryType.ScienceLibrary, LibraryType.HanaSquare].map({ "\($0.rawValue)" })
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        updateData()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: Action
    private func updateData() {
        kuStudy.requestSummaryData(onLibrarySuccess: { (libraryData) in
            
            }, onFailure: { (error) in
                
            }) { [weak self] (summaryData) in
                self?.summaryData = summaryData
                self?.updateView()
        }
    }
    
    private func updateView() {
        // Summary
        availableLabel.setText(summaryData.availableSeats?.readableFormat)
        percentageLabel.setText(summaryData.usedPercentage.readablePercentageFormat)
        percentageGroup.startAnimatingWithImagesInRange(
            NSRange(location: 0, length: Int(summaryData.usedPercentage * 100)),
            duration: 1, repeatCount: 1)
        
        // Campus
        var liberalArtsCampusAvailable = 0
        var scienceCampusAvailable = 0
        for libraryData in summaryData.libraries {
            if let libraryId = libraryData.libraryId {
                if liberalArtCampusIds.contains(libraryId) {
                    liberalArtsCampusAvailable += libraryData.availableSeats
                } else if scienceCampusIds.contains(libraryId) {
                    scienceCampusAvailable += libraryData.availableSeats
                }
            }
        }
        liberalArtCampusLabel.setText(String(liberalArtsCampusAvailable.readableFormat))
        scienceCampusLabel.setText(String(scienceCampusAvailable.readableFormat))
    }
}
