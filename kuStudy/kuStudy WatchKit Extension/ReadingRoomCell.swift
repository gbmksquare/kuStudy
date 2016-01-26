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
    
    func populate(readingRoom: ReadingRoomViewModel) {
        nameLabel.setText(readingRoom.name)
        availableLabel.setText(readingRoom.availableString)
        availableLabel.setTextColor(readingRoom.usedPercentageColor)
        percentGroup.setBackgroundColor(readingRoom.usedPercentageColor)
    }
}
