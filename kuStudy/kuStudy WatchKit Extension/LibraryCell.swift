//
//  LibraryCell.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 1..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import WatchKit

class LibraryCell: NSObject {
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var totalLabel: WKInterfaceLabel!
    @IBOutlet weak var availableLabel: WKInterfaceLabel!
    @IBOutlet weak var percentGroup: WKInterfaceGroup!
}
