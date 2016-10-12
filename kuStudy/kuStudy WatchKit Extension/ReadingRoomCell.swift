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
    @IBOutlet weak var availableLabel: WKInterfaceLabel!
    @IBOutlet weak var percentGroup: WKInterfaceGroup!
    
    func populate(_ sectorData: SectorData) {
        nameLabel.setText(sectorData.sectorName)
        availableLabel.setText(sectorData.availableSeats?.readable)
        availableLabel.setTextColor(sectorData.usedPercentageColor)
        percentGroup.setBackgroundColor(sectorData.usedPercentageColor)
    }
}
