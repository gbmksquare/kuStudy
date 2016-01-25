//
//  ReadingRoomTableViewCell.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class ReadingRoomTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedPercentage: UIProgressView!
    
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 3
    }
    
    // MARK: Populate
    func populate(readingRoom: ReadingRoomViewModel) {
        nameLabel.text = readingRoom.name
        totalLabel.text = readingRoom.totalString
        availableLabel.text = readingRoom.availableString
        usedPercentage.progress = readingRoom.usedPercentage
        usedPercentage.tintColor = readingRoom.usedPercentageColor
    }
}
