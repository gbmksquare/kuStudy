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
    private var summaryData = SummaryData()
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
        updateData()
        
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
        case "libraryDetail": return summaryData.libraries[rowIndex]
        default: return nil
        }
    }
    
    // MARK: Action
    @IBAction func tappedRefreshMenu() {
        updateData()
        updateView()
    }
    
    private func updateData() {
        summaryData.libraries.removeAll(keepingCapacity: true)
        kuStudy.requestSummaryData(onLibrarySuccess: { (libraryData) in
            
            }, onFailure: { (error) in
                print(error.localizedDescription)
            }) { [weak self] (summaryData) in
                self?.summaryData = summaryData
                self?.updateView()
        }
    }
    
    private func updateView() {
        reorderLibraryData()
        
        // Summary
        summaryLabel.setText(summaryData.usedSeats!.readable + Localizations.Watch.Label.Studyingdescription)
        percentageLabel.setText(summaryData.occupiedPercentage.percentageReadable)
        percentageGroup.startAnimatingWithImages(in:
            NSRange(location: 0, length: Int(summaryData.occupiedPercentage * 100)),
            duration: 1, repeatCount: 1)
        
        // Table
        table.setNumberOfRows(summaryData.libraries.count, withRowType: "libraryCell")
        for (index, libraryData) in summaryData.libraries.enumerated() {
            let row = table.rowController(at: index) as! LibraryCell
            row.populate(libraryData)
        }
    }
    
    private func reorderLibraryData() {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        orderedLibraryIds = defaults.array(forKey: "libraryOrder") as! [String]
        
        var orderedLibraries = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = summaryData.libraries.filter({ $0.libraryId! == libraryId }).first else { continue }
            orderedLibraries.append(libraryData)
        }
        summaryData.libraries = orderedLibraries
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
