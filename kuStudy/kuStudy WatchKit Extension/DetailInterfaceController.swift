//
//  DetailInterfaceController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 1..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import WatchKit
import kuStudyWatchKit

class DetailInterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var percentageGroup: WKInterfaceGroup!
    
    @IBOutlet weak var totalPlaceholderLabel: WKInterfaceLabel!
    @IBOutlet weak var usedPlaceholderLabel: WKInterfaceLabel!
    @IBOutlet weak var availablePlaceholderLabel: WKInterfaceLabel!
    
    @IBOutlet weak var totalLabel: WKInterfaceLabel!
    @IBOutlet weak var usedLabel: WKInterfaceLabel!
    @IBOutlet weak var availableLabel: WKInterfaceLabel!
    
    // Model
    private var library: LibraryType?
    private var libraryData: LibraryData?
    
    // Setup
    private func setup() {
        totalPlaceholderLabel.setText(Localizations.Watch.Label.Total)
        usedPlaceholderLabel.setText(Localizations.Watch.Label.Available)
        availablePlaceholderLabel.setText(Localizations.Watch.Label.Used)
    }
    
    // MARK: Watch
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdated(_:)), name: kuStudy.didUpdateDataNotification, object: nil)
        
        library = context as? LibraryType
        if let library = library {
            libraryData = kuStudy.libraryData(for: library)
        }
        updateView()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        startHandoff()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        invalidateUserActivity()
    }
    
    // MARK: Action
    @IBAction func tappedRefreshMenu() {
        kuStudy.requestUpdateData()
    }
    
    @objc private func handleDataUpdated(_ notification: Notification) {
        guard let library = library else { return }
        libraryData = kuStudy.libraryData(for: library)
    }
    
    private func updateView() {
        guard let library = library, let data = libraryData else { return }
        setTitle(library.name)
        totalLabel.setText(data.total.readable)
        usedLabel.setText(data.occupied.readable)
        availableLabel.setText(data.available.readable)
        availableLabel.setTextColor(data.occupiedPercentageColor)
        percentageGroup.startAnimatingWithImages(in:
            NSRange(location: 0, length: Int(data.occupiedPercentage * 100)),
            duration: 1, repeatCount: 1)
        
        // Refresh table
        guard let sectors = data.sectors else { return }
        table.setNumberOfRows(sectors.count, withRowType: "readingRoomCell")
        for (index, sectorData) in sectors.enumerated() {
            let row = table.rowController(at: index) as! ReadingRoomCell
            row.populate(sectorData)
        }
    }
}

// MARK: - Handoff
extension DetailInterfaceController {
    private func startHandoff() {
        guard let libraryId = libraryData?.libraryType?.identifier else { return }
        updateUserActivity(kuStudyHandoffLibrary, userInfo: [kuStudyHandoffLibraryIdKey: libraryId], webpageURL: nil)
    }
}
