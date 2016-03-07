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
    
    func populate(library: Library) {
        nameLabel.setText(library.name)
        availableLabel.setText(library.availableString)
        availableLabel.setTextColor(library.usedPercentageColor)
        usedLabel.setText(library.usedString)
        percentGroup.setBackgroundColor(library.usedPercentageColor)
    }
}
