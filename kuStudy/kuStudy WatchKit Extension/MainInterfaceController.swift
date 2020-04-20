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
    
    private var data = Summary() {
        didSet {
            organizeData()
        }
    }
    
    private var orderedData = [Library]() {
        didSet {
            updateView()
        }
    }
    
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
        setTitle("studyArea".localizedFromKit())
        loadingMessageGroup.setHidden(false)
        loadingMessageLabel.setText("loading".localized())
        table.setHidden(true)
        addMenuItem(withImageNamed: "glyphicons-82-refresh", title: "refresh".localized(), action: #selector(handleRefreshMenu))
    }
    
    // MARK: - Segue
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        switch segueIdentifier {
        case "detail":
            return orderedData[rowIndex]
        default: return nil
        }
    }
    
    // MARK: - Action
    private func registerPreferences() {
        let defaults = UserDefaults.standard
        let libraryOrder = LibraryType.all.map({ $0.rawValue })
        defaults.register(defaults: ["libraryOrder": libraryOrder])
        defaults.synchronize()
    }
    
    private func listenForDataUpdate() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(dataUpdate:)),
                                               name: DataManager.didUpdateNotification,
                                               object: nil)
    }
    
    @objc private func handleRefreshMenu() {
        updateData()
    }
    
    @objc private func handle(dataUpdate notification: Notification) {
        data = DataManager.shared.summary()
    }
    
    // MARK: - Action
    private func updateData() {
        DataManager.shared.requestUpdate()
    }
    
    private func updateView() {
        if orderedData.count > 0 {
            loadingMessageGroup.setHidden(true)
            table.setHidden(false)
            table.setNumberOfRows(orderedData.count, withRowType: "cell")
            orderedData.enumerated().forEach { (index, data) in
                let row = table.rowController(at: index) as! LibraryRow
                row.populate(library: data)
            }
        } else {
            loadingMessageGroup.setHidden(false)
            table.setHidden(true)
            loadingMessageLabel.setText("error".localized())
        }
    }
    
    private func organizeData() {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        orderedLibraryIds = defaults.array(forKey: "libraryOrder") as? [String]
        orderedData = orderedLibraryIds.compactMap { identifier in
            data.libraries.first { identifier == $0.type.identifier }
        }
    }
    
    // MARK: - Handoff
    private func startHandoff() {
        let activity = NSUserActivity(activityType: NSUserActivity.ActivityType.summary.rawValue)
        activity.userInfo = [NSUserActivity.ActivityType.summary.rawValue: NSUserActivity.ActivityType.summary.rawValue]
        update(activity)
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
