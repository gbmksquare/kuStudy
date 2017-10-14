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
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    @IBOutlet private weak var bottomStackView: UIStackView!
    @IBOutlet private weak var dataStackView: UIStackView!
    @IBOutlet private weak var availablePlaceholderLabel: UILabel!
    @IBOutlet private weak var totalPlaceholderLabel: UILabel!
    @IBOutlet private weak var usedPlaceholderLabel: UILabel!
    
    @IBOutlet private weak var availableLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var usedLabel: UILabel!

    // MARK: View
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setEmpty()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = indicatorView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        indicatorView.backgroundColor = color
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = indicatorView.backgroundColor
        super.setSelected(selected, animated: animated)
        indicatorView.backgroundColor = color
    }
    
    // MARK: UI
    private func setup() {
        indicatorView.layer.cornerRadius = indicatorView.bounds.width / 2
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        
        if #available(iOS 11.0, *) {
            indicatorView.accessibilityIgnoresInvertColors = true
            thumbnailImageView.accessibilityIgnoresInvertColors = true
        }
    }
    
    func updateInterface(for traitCollectoin: UITraitCollection) {
        if traitCollection.preferredContentSizeCategory == .accessibilityLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraExtraLarge {
            bottomStackView.axis = .vertical
            dataStackView.axis = .vertical
        } else {
            bottomStackView.axis = .horizontal
            dataStackView.axis = .horizontal
        }
    }
    
    // MARK: Populate
    private func setEmpty() {
        thumbnailImageView.image = nil
        nameLabel.text = Localizations.Common.Nodata
        availablePlaceholderLabel.text = Localizations.Common.Available
        totalPlaceholderLabel.text = Localizations.Common.Total
        usedPlaceholderLabel.text = Localizations.Common.Used
        availableLabel.text = Localizations.Common.Nodata
        totalLabel.text = Localizations.Common.Nodata
        usedLabel.text = Localizations.Common.Nodata
        indicatorView.backgroundColor = UIColor.lightGray
    }
    
    func populate(library: LibraryData?) {
        guard let library = library else {
            setEmpty()
            return
        }
        guard let libraryId = library.libraryId else {
            setEmpty()
            return
        }
        
        let libraryType = LibraryType(rawValue: libraryId)
        nameLabel.text = libraryType?.name
        availableLabel.text =  library.availableSeats.readable
        totalLabel.text = library.totalSeats.readable
        usedLabel.text = library.usedSeats.readable
        
        thumbnailImageView.image = library.media?.thumbnail
        indicatorView.backgroundColor = library.availablePercentageColor
    }
}
