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
    @IBOutlet weak var availableLabel: WKInterfaceLabel!
    @IBOutlet weak var usedLabel: WKInterfaceLabel!
    @IBOutlet weak var percentGroup: WKInterfaceGroup!
    
    func populate(libraryData: LibraryData) {
        guard let libraryId = libraryData.libraryId else { return }
        guard let libraryType = LibraryType(rawValue: libraryId) else { return }
        nameLabel.setText(libraryType.name)
        availableLabel.setText(libraryData.availableSeats?.readableFormat)
        usedLabel.setText(libraryData.usedSeats?.readableFormat)
        availableLabel.setTextColor(libraryData.usedPercentageColor)
        percentGroup.setBackgroundColor(libraryData.usedPercentageColor)
    }
}
