//
//  LibraryCell.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 1..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import WatchKit
import kuStudyWatchKit

class LibraryCell: NSObject {
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var availablePlaceholderLabel: WKInterfaceLabel!
    @IBOutlet weak var availableLabel: WKInterfaceLabel!
    @IBOutlet weak var usedPlaceholderLabel: WKInterfaceLabel!
    @IBOutlet weak var usedLabel: WKInterfaceLabel!
    @IBOutlet weak var percentGroup: WKInterfaceGroup!
    
    func populate(_ libraryData: LibraryData) {
        availablePlaceholderLabel.setText(Localizations.Watch.Cell.Label.Available)
        usedPlaceholderLabel.setText(Localizations.Watch.Cell.Label.Used)
        
        nameLabel.setText(libraryData.libraryName)
        availableLabel.setText(libraryData.availableSeats.readable)
        usedLabel.setText(libraryData.usedSeats.readable)
        percentGroup.setBackgroundColor(libraryData.occupiedPercentageColor)
    }
}
