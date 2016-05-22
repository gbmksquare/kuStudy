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
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var usedPercentageView: UIProgressView!
    
    // MARK: Populate
    func populate(sectorData: SectorData) {
        guard let name = sectorData.sectorName,
            availableSeats = sectorData.availableSeats,
            usedSeats = sectorData.usedSeats
            else { return }
        nameLabel.text = name
        availableLabel.text = availableSeats.readableFormat
        usedLabel.text = usedSeats.readableFormat
        
        usedPercentageView.progress = sectorData.usedPercentage
        usedPercentageView.tintColor = sectorData.usedPercentageColor
    }
}
