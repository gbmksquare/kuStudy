//
//  MainInterfaceController.swift
//  kuStudy WatchKit Extension
//
//  Created by BumMo Koo on 12/10/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import WatchKit
import WatchConnectivity
import kuStudyWatchKit

class MainInterfaceController: WKInterfaceController {
    @IBOutlet var loadingMessageGroup: WKInterfaceGroup!
    @IBOutlet var loadingMessageLabel: WKInterfaceLabel!
    @IBOutlet var table: WKInterfaceTable!
    
    private var session: WCSession?
    
    private var summary: SummaryData?
    private var orderedLibraryIds: [String]!
    
    // MARK: - Watch
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        registerPreferences()
        setup()
        listenForDataUpdate()
        updateData()
        
        if WCSession.isSupported() == true {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    override func willActivate() {
        super.willActivate()
        startHandoff()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        stopHandoff()
    }
    
    // MARK: - Setup
    private func setup() {
        setTitle(Localizations.Label.AppName)
        loadingMessageGroup.setHidden(false)
        loadingMessageLabel.setText(Localizations.Label.Loading)
        table.setHidden(true)
        addMenuItem(withImageNamed: "glyphicons-82-refresh", title: Localizations.Action.Refresh, action: #selector(handleRefreshMenu))
    }
    
    // MARK: - Segue
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        switch segueIdentifier {
        case "detail":
            return summary?.libraries[rowIndex].libraryType ?? nil
        default: return nil
        }
    }
    
    // MARK: - Action
    private func registerPreferences() {
        let defaults = UserDefaults.standard
        let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
        defaults.register(defaults: ["libraryOrder": libraryOrder])
        defaults.synchronize()
    }
    
    private func listenForDataUpdate() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(dataUpdate:)),
                                               name: kuStudy.didUpdateDataNotification,
                                               object: nil)
    }
    
    private func updateData() {
        kuStudy.requestUpdateData()
    }
    
    private func updateView() {
        if let summary = summary {
            loadingMessageGroup.setHidden(true)
            table.setHidden(false)
            reorderLibraryData()
            table.setNumberOfRows(summary.libraries.count, withRowType: "cell")
            for (index, data) in summary.libraries.enumerated() {
                let row = table.rowController(at: index) as! LibraryRow
                row.populate(library: data)
            }
        } else {
            loadingMessageGroup.setHidden(false)
            table.setHidden(true)
            loadingMessageLabel.setText(Localizations.Label.Error)
        }
    }
    
    @objc private func handleRefreshMenu() {
        updateData()
    }
    
    @objc private func handle(dataUpdate notification: Notification) {
        summary = kuStudy.summaryData
        updateView()
    }
    
    private func reorderLibraryData() {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        orderedLibraryIds = defaults.array(forKey: "libraryOrder") as? [String]
        
        var orderedLibraries = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = summary?.libraries.filter({ $0.libraryType!.identifier == libraryId }).first else { continue }
            orderedLibraries.append(libraryData)
        }
        summary?.libraries = orderedLibraries
    }
    
    // MARK: - Handoff
    private func startHandoff() {
        updateUserActivity(kuStudyHandoffSummary,
                           userInfo: [kuStudyHandoffSummaryKey: kuStudyHandoffSummaryKey],
                           webpageURL: nil)
    }
    
    private func stopHandoff() {
        invalidateUserActivity()
    }
}

// MARK: - Connectivity
extension MainInterfaceController: WCSessionDelegate {
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
