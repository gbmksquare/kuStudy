//
//  LibraryTableViewCell.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 9..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

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
        totalPlaceholderLabel.text = Localizations.Cell.Label.Total
        availablePlaceholderLabel.text = Localizations.Cell.Label.Available
        usedPlaceholderLabel.text = Localizations.Cell.Label.Used
        indicatorView.layer.cornerRadius = indicatorView.bounds.width / 2
        indicatorView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.95, alpha: 1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        totalLabel.text = Localizations.Cell.Label.NoData
        availableLabel.text = Localizations.Cell.Label.NoData
        usedLabel.text = Localizations.Cell.Label.NoData
    }
    
    // MARK: Populate
    func populate(_ data: LibraryData) {
        guard let library = data.libraryType else { return }
        
        nameLabel.text = library.name
        totalLabel.text = data.total.readable
        availableLabel.text = data.available.readable
        usedLabel.text = data.occupied.readable
        
        indicatorView.backgroundColor = data.availablePercentageColor
    }
}
