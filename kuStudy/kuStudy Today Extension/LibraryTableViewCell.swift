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
    
    @IBOutlet weak var totalPlaceholderLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var availablePlaceholderLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedPlaceholderLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    
    // MARK: View
    override func awakeFromNib() {
        super.awakeFromNib()
        totalPlaceholderLabel.text = "kuStudy.Today.Total".localized()
        availablePlaceholderLabel.text = "kuStudy.Today.Available".localized()
        usedPlaceholderLabel.text = "kuStudy.Today.Used".localized()
        indicatorView.layer.cornerRadius = indicatorView.bounds.width / 2
        indicatorView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.95, alpha: 1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        totalLabel.text = "kuStudy.Today.EmptyData".localized()
        availableLabel.text = "kuStudy.Today.EmptyData".localized()
        usedLabel.text = "kuStudy.Today.EmptyData".localized()
    }
    
    // MARK: Populate
    func populate(_ libraryData: LibraryData) {
        guard let libraryId = libraryData.libraryId else { return }
        
        let libraryType = LibraryType(rawValue: libraryId)
        nameLabel.text = libraryType?.name
        totalLabel.text = libraryData.totalSeats.readable
        availableLabel.text = libraryData.availableSeats.readable
        usedLabel.text = libraryData.usedSeats.readable
        
        indicatorView.backgroundColor = libraryData.availablePercentageColor
    }
}
