//
//  InterfaceController.swift
//  kuStudy WatchKit Extension
//
//  Created by 구범모 on 2015. 6. 1..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import WatchKit
import Foundation
import kuStudyWatchKit

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var percentageLabel: WKInterfaceLabel!
    @IBOutlet weak var percentageGroup: WKInterfaceGroup!
    @IBOutlet weak var summaryLabel: WKInterfaceLabel!
    
    // MARK: Model
    private var summary: Summary?
    private var libraries = [Library]()
    
    // MARK: Watch
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        fetchData()
        
        // Handoff
        updateUserActivity(kuStudyHandoffSummary, userInfo: [kuStudyHandoffSummaryKey: kuStudyHandoffSummaryKey], webpageURL: nil)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: Segue
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        switch segueIdentifier {
        case "libraryDetail": return [libraries[rowIndex].id]
        default: return nil
        }
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
    
    private func updateDataInView() {
        // Summary
        if let summary = summary {
            summaryLabel.setText(summary.usedString + NSLocalizedString("summary_used_description", bundle: NSBundle(forClass: self.dynamicType), comment: "Describe how many people are studying."))
            percentageLabel.setText(summary.usedPercentageString)
            percentageGroup.startAnimatingWithImagesInRange(
                NSRange(location: 0, length: Int(summary.usedPercentage * 100)),
                duration: 1, repeatCount: 1)
        }
        
        // Table
        table.setNumberOfRows(libraries.count, withRowType: "libraryCell")
        for index in 0 ..< libraries.count {
            let library = libraries[index]
            let row = table.rowControllerAtIndex(index) as! LibraryCell
            row.populate(library)
        }
    }
}
