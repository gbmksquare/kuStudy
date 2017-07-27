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
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
  
    @IBOutlet private weak var dataStackView: UIStackView!
    @IBOutlet private weak var availablePlaceholderLabel: UILabel!
    @IBOutlet private weak var totalPlaceholderLabel: UILabel!
    @IBOutlet private weak var usedPlaceholderLabel: UILabel!
    
    @IBOutlet private weak var availableLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var usedLabel: UILabel!
    
    @IBOutlet private weak var usedProgressView: UIProgressView!
    
    // MARK: View
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.layer.cornerRadius = indicatorView.bounds.width / 2
        availablePlaceholderLabel.text = "kuStudy.Available".localized()
        setEmpty()
    }
    
    // MARK: UI
    func updateInterface(for traitCollectoin: UITraitCollection) {
        if traitCollection.preferredContentSizeCategory == .accessibilityLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraExtraLarge {
            dataStackView.axis = .vertical
        } else {
            dataStackView.axis = .horizontal
        }
    }
    
    // MARK: Populate
    private func setEmpty() {
        nameLabel.text = "kuStudy.NoData".localized()
        availablePlaceholderLabel.text = "kuStudy.Available".localized()
        totalPlaceholderLabel.text = "kuStudy.Total".localized()
        usedPlaceholderLabel.text = "kuStudy.Used".localized()
        
        availableLabel.text = "kuStudy.NoData".localized()
        totalLabel.text = "kuStudy.NoData".localized()
        usedLabel.text = "kuStudy.NoData".localized()
        
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
        availableLabel.text =  availableSeats.readable
        totalLabel.text = totalSeats.readable
        usedLabel.text = usedSeats.readable
        
        indicatorView.backgroundColor = sector.usedPercentageColor
        usedProgressView.progress = sector.usedPercentage
        usedProgressView.tintColor = sector.usedPercentageColor
    }
}
