//
//  LibraryCell.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 1. 26..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedPercentageView: UIProgressView!
    
    func populate(library: Library) {
        nameLabel.text = library.name
        availableLabel.text = library.availableString
        usedPercentageView.progress = library.usedPercentage
        usedPercentageView.tintColor = library.usedPercentageColor
    }
}
