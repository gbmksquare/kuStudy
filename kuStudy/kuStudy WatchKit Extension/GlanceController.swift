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
    private var summary: Summary?
    private var libraries = [Library]()
    
    private let liberalArtCampusIds = [1, 2, 5]
    private let scienceCampusIds = [3, 4]
    
    // MARK: Watch
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        fetchData()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: Action
    private func fetchData() {
        kuStudy.requestSeatSummary({ [weak self] (summary, libraries) -> Void in
                self?.summary = summary
                self?.libraries = libraries
                self?.updateDataInView()
            }) { (error) -> Void in
                
        }
    }
    
    // MARK: Data
    private func updateDataInView() {
        // Summary
        if let summary = summary {
            availableLabel.setText(summary.availableString)
            percentageLabel.setText(summary.usedPercentageString)
            percentageGroup.startAnimatingWithImagesInRange(
                NSRange(location: 0, length: Int(summary.usedPercentage * 100)),
                duration: 1, repeatCount: 1)
        }
        
        // Campus
        var liberalArtsCampusAvailable = 0
        var scienceCampusAvailable = 0
        for library in libraries {
            if liberalArtCampusIds.contains(library.id) {
                liberalArtsCampusAvailable += library.available
            } else if scienceCampusIds.contains(library.id) {
                scienceCampusAvailable += library.available
            }
        }
        liberalArtCampusLabel.setText(String(liberalArtsCampusAvailable))
        scienceCampusLabel.setText(String(scienceCampusAvailable))
    }
}
