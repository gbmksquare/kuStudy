//
//  LibraryTableViewCell.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var usedPercentageView: UIProgressView!
    
    // MARK: Populate
    func populate(library: LibraryViewModel) {
        nameLabel.text = library.name
        availableLabel.text = library.availableString
        usedLabel.text = library.usedString
        usedPercentageView.progress = library.usedPercentage
        usedPercentageView.tintColor = library.usedPercentageColor
    }
}
