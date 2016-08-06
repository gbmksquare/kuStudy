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
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var usedPercentageView: UIProgressView!
    
    // MARK: Populate
    func populate(sectorData: SectorData) {
        guard let name = sectorData.sectorName,
            totalSeats = sectorData.totalSeats,
            availableSeats = sectorData.availableSeats,
            usedSeats = sectorData.usedSeats
            else { return }
        
        nameLabel.text = name
        availableLabel.text = availableSeats.readableFormat + " " + "kuStudy.Available".localized()
        
        usedLabel.text = usedSeats.readableFormat + " " + "kuStudy.Used".localized()
        totalLabel.text = totalSeats.readableFormat + " " + "kuStudy.Total".localized()
        usedPercentageView.progress = sectorData.usedPercentage
        usedPercentageView.tintColor = sectorData.usedPercentageColor
    }
}
