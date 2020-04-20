//
//  ReadingRoomRow.swift
//  kuStudy WatchKit Extension
//
//  Created by BumMo Koo on 12/10/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import WatchKit
import kuStudyWatchKit

class ReadingRoomRow: NSObject {
    @IBOutlet var percentIndicator: WKInterfaceGroup!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var availableLabel: WKInterfaceLabel!
    @IBOutlet var availableTitleLabel: WKInterfaceLabel!
    
    func populate(sector data: StudyArea) {
        percentIndicator.setBackgroundColor(data.availablePercentage.color)
        titleLabel.setText(data.name)
        availableLabel.setText(data.availableSeats.readable)
        availableTitleLabel.setText("available".localizedFromKit())
    }
}
