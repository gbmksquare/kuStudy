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
    func updateEmptyView() {
        nameLabel.text = "--"
        availableLabel.text = "--"
        totalLabel.text = "--"
        usedLabel.text = "--"
        usedPercentageView.progress = 0
    }
    
    func populate(_ sectorData: SectorData?) {
        guard let sectorData = sectorData else {
            updateEmptyView()
            return
        }
        guard let name = sectorData.sectorName, let totalSeats = sectorData.totalSeats,
            let availableSeats = sectorData.availableSeats, let usedSeats = sectorData.usedSeats else {
                updateEmptyView()
                return
        }
        
        nameLabel.text = name
        availableLabel.text =  availableSeats.readable + "  " + "kuStudy.Available".localized()
        usedLabel.text = "kuStudy.Used".localized() + ": " + usedSeats.readable
        totalLabel.text = "kuStudy.Total".localized() + ": " + totalSeats.readable
        
        usedPercentageView.progress = sectorData.usedPercentage
        usedPercentageView.tintColor = sectorData.usedPercentageColor
    }
}
