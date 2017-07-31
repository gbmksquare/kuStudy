//
//  ReadingRoomCell.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 3..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import WatchKit
import kuStudyWatchKit

class ReadingRoomCell: NSObject {
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var availablePlaceholderLabel: WKInterfaceLabel!
    @IBOutlet weak var availableLabel: WKInterfaceLabel!
    @IBOutlet weak var usedPlaceholderLabel: WKInterfaceLabel!
    @IBOutlet weak var usedLabel: WKInterfaceLabel!
    @IBOutlet weak var percentGroup: WKInterfaceGroup!
    
    func populate(_ sectorData: SectorData) {
        availablePlaceholderLabel.setText(Localizations.Watch.Cell.Label.Available)
        usedPlaceholderLabel.setText(Localizations.Watch.Cell.Label.Used)
        
        nameLabel.setText(sectorData.sectorName)
        availableLabel.setText(sectorData.availableSeats?.readable)
        usedLabel.setText(sectorData.usedSeats?.readable)
        percentGroup.setBackgroundColor(sectorData.usedPercentageColor)
    }
}
