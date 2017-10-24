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
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var percentageLabel: WKInterfaceLabel!
    @IBOutlet weak var percentageGroup: WKInterfaceGroup!
    @IBOutlet weak var summaryLabel: WKInterfaceLabel!
    
    private var session: WCSession?
    
    // MARK: Model
    private var summary: SummaryData?
    private var orderedLibraryIds: [String]!
    
    // MARK: Watch
    override func awake(withContext context: Any?) {
        func registerDefaultPreferences() {
            let defaults = UserDefaults.standard
            let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
            defaults.register(defaults: ["libraryOrder": libraryOrder])
            defaults.synchronize()
        }
        
        super.awake(withContext: context)
        registerDefaultPreferences()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdated(_:)), name: kuStudy.didUpdateDataNotification, object: nil)
        kuStudy.requestUpdateData()
        
        if WCSession.isSupported() == true {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
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
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        switch segueIdentifier {
        case "libraryDetail": return summary?.libraries[rowIndex].libraryType ?? nil
        default: return nil
        }
    }
    
    // MARK: Action
    @IBAction func tappedRefreshMenu() {
        kuStudy.requestUpdateData()
    }
    
    @objc private func handleDataUpdated(_ notification: Notification) {
        summary = kuStudy.summaryData
        self.updateView()
    }
    
    private func updateView() {
        guard let summary = summary else { return }
        
        reorderLibraryData()
        
        // Summary
        summaryLabel.setText(summary.occupied!.readable + Localizations.Label.StudyingDescription)
        percentageLabel.setText(summary.occupiedPercentage.percentageReadable)
        percentageGroup.startAnimatingWithImages(in:
            NSRange(location: 0, length: Int(summary.occupiedPercentage * 100)),
            duration: 1, repeatCount: 1)
        
        // Table
        table.setNumberOfRows(summary.libraries.count, withRowType: "libraryCell")
        for (index, libraryData) in summary.libraries.enumerated() {
            let row = table.rowController(at: index) as! LibraryCell
            row.populate(libraryData)
        }
    }
    
    private func reorderLibraryData() {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        orderedLibraryIds = defaults.array(forKey: "libraryOrder") as! [String]
        
        var orderedLibraries = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = summary?.libraries.filter({ $0.libraryType!.identifier == libraryId }).first else { continue }
            orderedLibraries.append(libraryData)
        }
        summary?.libraries = orderedLibraries
    }
}

// MARK: - Handoff
extension InterfaceController {
    private func startHandOff() {
        updateUserActivity(kuStudyHandoffSummary, userInfo: [kuStudyHandoffSummaryKey: kuStudyHandoffSummaryKey], webpageURL: nil)
    }
}

// MARK: - Watch connectivity
extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let libraryOrder = applicationContext["libraryOrder"] as? [String] else { return }
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["libraryOrder": libraryOrder])
        defaults.synchronize()
        updateView()
    }
}
