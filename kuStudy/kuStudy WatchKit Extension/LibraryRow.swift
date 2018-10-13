//
//  LibraryRow.swift
//  kuStudy WatchKit Extension
//
//  Created by BumMo Koo on 12/10/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import WatchKit
import kuStudyWatchKit

class LibraryRow: NSObject {
    @IBOutlet var percentIndicator: WKInterfaceGroup!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var availableLabel: WKInterfaceLabel!
    @IBOutlet var availableTitleLabel: WKInterfaceLabel!
    
    func populate(library data: LibraryData) {
        percentIndicator.setBackgroundColor(data.availablePercentageColor)
        titleLabel.setText(data.libraryName)
        availableLabel.setText(data.available.readable)
        availableTitleLabel.setText(Localizations.Label.Available)
    }
}
