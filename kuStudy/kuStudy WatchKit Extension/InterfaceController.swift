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
    private var summaryData = SummaryData()
    private var orderedLibraryIds: [String]!
    
    // MARK: Watch
    override func awakeWithContext(context: AnyObject?) {
        func registerDefaultPreferences() {
            let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
            let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
            defaults.registerDefaults(["libraryOrder": libraryOrder,
                "todayExtensionOrder": libraryOrder,
                "todayExtensionHidden": []])
            defaults.synchronize()
        }
        
        super.awakeWithContext(context)
        registerDefaultPreferences()
        updateData()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        startHandOff()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        invalidateUserActivity()
    }
    
    // MARK: Segue
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        switch segueIdentifier {
        case "libraryDetail": return summaryData.libraries[rowIndex]
        default: return nil
        }
    }
    
    // MARK: Action
    @IBAction func tappedRefreshMenu() {
        updateData()
    }
    
    private func updateData() {
        summaryData.libraries.removeAll(keepCapacity: true)
        kuStudy.requestSummaryData(onLibrarySuccess: { (libraryData) in
            
            }, onFailure: { (error) in
                
            }) { [weak self] (summaryData) in
                self?.summaryData = summaryData
                self?.reorderLibraryData()
                self?.updateView()
        }
    }
    
    private func updateView() {
        // Summary
        summaryLabel.setText(summaryData.usedSeats!.readableFormat + NSLocalizedString("kuStudy.Watch.StudyingDescription", bundle: NSBundle(forClass: self.dynamicType), comment: "Describe how many people are studying."))
        percentageLabel.setText(summaryData.usedPercentage.readablePercentageFormat)
        percentageGroup.startAnimatingWithImagesInRange(
            NSRange(location: 0, length: Int(summaryData.usedPercentage * 100)),
            duration: 1, repeatCount: 1)
        
        // Table
        table.setNumberOfRows(summaryData.libraries.count, withRowType: "libraryCell")
        for (index, libraryData) in summaryData.libraries.enumerate() {
            let row = table.rowControllerAtIndex(index) as! LibraryCell
            row.populate(libraryData)
        }
    }
    
    private func reorderLibraryData() {
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        orderedLibraryIds = defaults.arrayForKey("libraryOrder") as! [String]
        
        var orderedLibraries = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = summaryData.libraries.filter({ $0.libraryId! == libraryId }).first else { continue }
            orderedLibraries.append(libraryData)
        }
        summaryData.libraries = orderedLibraries
    }
}

// MARK:
// MARK: Handoff
extension InterfaceController {
    private func startHandOff() {
        updateUserActivity(kuStudyHandoffSummary, userInfo: [kuStudyHandoffSummaryKey: kuStudyHandoffSummaryKey], webpageURL: nil)
    }
}
