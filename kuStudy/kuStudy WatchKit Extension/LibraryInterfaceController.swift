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
    
    private var libraryType: LibraryType?
    private var libraryData: LibraryData?
    
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
        libraryType = context as? LibraryType
        if let libraryType = libraryType {
            libraryData = kuStudy.libraryData(for: libraryType)
        }
        setTitle(libraryType?.name ?? Localizations.Label.AppName)
        loadingMessageGroup.setHidden(true)
        loadingMessageLabel.setText(Localizations.Label.Loading)
        table.setHidden(false)
        addMenuItem(withImageNamed: "glyphicons-82-refresh", title: Localizations.Action.Refresh, action: #selector(handleRefreshMenu))
    }
    
    // MARK: - Action
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
        if let libraryData = libraryData, let sectors = libraryData.sectors {
            loadingMessageGroup.setHidden(true)
            table.setHidden(false)
            table.setNumberOfRows(sectors.count, withRowType: "cell")
            for (index, data) in sectors.enumerated() {
                let row = table.rowController(at: index) as! ReadingRoomRow
                row.populate(sector: data)
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
        updateView()
    }
    
    // MARK: - Handoff
    private func startHandoff() {
        guard let libraryId = libraryData?.libraryType?.identifier else { return }
        updateUserActivity(kuStudyHandoffLibrary, userInfo: [kuStudyHandoffLibraryIdKey: libraryId], webpageURL: nil)
    }
    
    private func stopHandoff() {
        invalidateUserActivity()
    }
}
