//
//  LibraryInterfaceController.swift
//  kuStudy WatchKit Extension
//
//  Created by BumMo Koo on 12/10/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import WatchKit
import WatchConnectivity
import kuStudyWatchKit

class LibraryInterfaceController: WKInterfaceController {
    @IBOutlet var loadingMessageGroup: WKInterfaceGroup!
    @IBOutlet var loadingMessageLabel: WKInterfaceLabel!
    @IBOutlet var table: WKInterfaceTable!
    
    private var data: Library!
    
    // MARK: - Watch
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setup(context: context)
        listenForDataUpdate()
        updateView()
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
    private func setup(context: Any?) {
        data = context as? Library
        setTitle(data.name)
        loadingMessageGroup.setHidden(true)
        loadingMessageLabel.setText("loading".localized())
        table.setHidden(false)
        addMenuItem(withImageNamed: "glyphicons-82-refresh", title:
            "refresh".localized(), action: #selector(handleRefreshMenu))
    }
    
    // MARK: - Action
    private func listenForDataUpdate() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(dataUpdate:)),
                                               name: DataManager.didUpdateNotification,
                                               object: nil)
    }
    
    private func updateData() {
        DataManager.shared.requestUpdate()
    }
    
    private func updateView() {
        if data.studyAreas.count > 0 {
            loadingMessageGroup.setHidden(true)
            table.setHidden(false)
            table.setNumberOfRows(data.studyAreas.count, withRowType: "cell")
            for (index, data) in data.studyAreas.enumerated() {
                let row = table.rowController(at: index) as! ReadingRoomRow
                row.populate(sector: data)
            }
        } else {
            loadingMessageGroup.setHidden(false)
            table.setHidden(true)
            loadingMessageLabel.setText("error".localized())
        }
    }
    
    @objc private func handleRefreshMenu() {
        updateData()
    }
    
    @objc private func handle(dataUpdate notification: Notification) {
        updateView()
    }
    
    // MARK: - Handoff
    private func startHandoff() {
        let libraryId = data.type.identifier
        let activity = NSUserActivity(activityType: NSUserActivity.ActivityType.library.rawValue)
        activity.userInfo = [NSUserActivity.ActivityType.library.rawValue: libraryId]
        update(activity)
    }
    
    private func stopHandoff() {
        invalidateUserActivity()
    }
}
