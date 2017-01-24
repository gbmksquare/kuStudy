//
//  ReadingRoomTableViewCell.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import Localize_Swift

class ReadingRoomTableViewCell: UITableViewCell {
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var availableDataLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var usedProgressView: UIProgressView!
    
    // MARK: View
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.layer.cornerRadius = indicatorView.bounds.width / 2
        availableLabel.text = "kuStudy.Available".localized()
        setEmpty()
    }
    
    // MARK: Populate
    private func setEmpty() {
        nameLabel.text = "--"
        availableDataLabel.text = "--"
        totalLabel.text = "kuStudy.Total".localized() + ": --"
        usedLabel.text = "kuStudy.Used".localized() + ": --"
        indicatorView.backgroundColor = UIColor.lightGray
        usedProgressView.progress = 0
    }
    
    func populate(sector: SectorData?) {
        guard let sector = sector else {
            setEmpty()
            return
        }
        guard let name = sector.sectorName,
            let totalSeats = sector.totalSeats,
            let availableSeats = sector.availableSeats,
            let usedSeats = sector.usedSeats else {
                setEmpty()
                return
        }
        
        nameLabel.text = name
        availableDataLabel.text =  availableSeats.readable
        totalLabel.text = "kuStudy.Total".localized() + ": " + totalSeats.readable
        usedLabel.text = "kuStudy.Used".localized() + ": " + usedSeats.readable
        
        indicatorView.backgroundColor = sector.usedPercentageColor
        usedProgressView.progress = sector.usedPercentage
        usedProgressView.tintColor = sector.usedPercentageColor
    }
}
