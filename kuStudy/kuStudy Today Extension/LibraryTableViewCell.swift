//
//  LibraryTableViewCell.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 9..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import Localize_Swift

class LibraryTableViewCell: UITableViewCell {
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalDataLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var availableDataLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var usedPercentageLabel: UILabel!
    
    // MARK: Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        totalLabel.text = "kuStudy.Today.Total".localized()
        availableLabel.text = "kuStudy.Today.Available".localized()
        usedLabel.text = "kuStudy.Today.Used".localized()
        indicatorView.layer.cornerRadius = indicatorView.bounds.width / 2
        indicatorView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.95, alpha: 1)
    }
    
    // MARK: Populate
    func populate(_ libraryData: LibraryData) {
        guard let libraryId = libraryData.libraryId else { return }
        
        let libraryType = LibraryType(rawValue: libraryId)
        nameLabel.text = libraryType?.name
        totalDataLabel.text = libraryData.totalSeats.readable
        availableDataLabel.text = libraryData.availableSeats.readable
        usedPercentageLabel.text = libraryData.usedPercentage.percentageReadable
        
        indicatorView.backgroundColor = libraryData.availablePercentageColor
    }
}
