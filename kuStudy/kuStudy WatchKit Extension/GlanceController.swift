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
    
    @IBOutlet weak var centralLibraryNameLabel: WKInterfaceLabel!
    @IBOutlet weak var centralSquareNameLabel: WKInterfaceLabel!
    @IBOutlet weak var hanaSquareNameLabel: WKInterfaceLabel!
    @IBOutlet weak var scienceLibraryNameLabel: WKInterfaceLabel!
    @IBOutlet weak var cdlNameLabel: WKInterfaceLabel!
    @IBOutlet weak var sejongNameLabel: WKInterfaceLabel!
    
    @IBOutlet weak var centralLibraryAvailableLabel: WKInterfaceLabel!
    @IBOutlet weak var centralSquareAvailableLabel: WKInterfaceLabel!
    @IBOutlet weak var hanaSquareAvailableLabel: WKInterfaceLabel!
    @IBOutlet weak var scienceLibraryAvailableLabel: WKInterfaceLabel!
    @IBOutlet weak var cdlAvailableLabel: WKInterfaceLabel!
    @IBOutlet weak var sejongAvailableLabel: WKInterfaceLabel!
    
    // MARK: Model
    var summary: Summary?
    var libraries = [Library]()
    
    // MARK: Data
    private func refreshData() {
        // Summary
        if let summary = summary {
            let summaryViewModel = SummaryViewModel(summary: summary)
            availableLabel.setText(summaryViewModel.availableString)
            percentageLabel.setText(summaryViewModel.usedPercentageString)
            percentageGroup.startAnimatingWithImagesInRange(
                NSRange(location: 0, length: Int(summaryViewModel.usedPercentage * 100)),
                duration: 1, repeatCount: 1)
        }
        
        // Libraries
        let nameLabels = [centralLibraryNameLabel, centralSquareNameLabel, hanaSquareNameLabel, scienceLibraryNameLabel, cdlNameLabel, sejongNameLabel]
        let availableLabels = [centralLibraryAvailableLabel, centralSquareAvailableLabel, hanaSquareAvailableLabel, scienceLibraryAvailableLabel, cdlAvailableLabel, sejongAvailableLabel]
        for index in 0 ..< libraries.count {
            let library = libraries[index]
            let libraryViewModel = LibraryViewModel(library: library)
            
            let nameLabel = nameLabels[index]
            let availableLabel = availableLabels[index]
            nameLabel.setText(libraryViewModel.name)
            availableLabel.setText(libraryViewModel.availableString)
        }
    }

    // MARK: Watch
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        kuStudy.requestSeatSummary({ (summary, libraries) -> Void in
            self.summary = summary
            self.libraries = libraries
            self.refreshData()
            }) { (error) -> Void in
                
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
