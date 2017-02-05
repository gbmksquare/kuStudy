//
//  LibraryTableViewCell.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import Localize_Swift

class LibraryTableViewCell: UITableViewCell {
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var availablePlaceholderLabel: UILabel!
    @IBOutlet weak var totalPlaceholderLabel: UILabel!
    @IBOutlet weak var usedPlaceholderLabel: UILabel!
    
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!

    // MARK: View
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        indicatorView.layer.cornerRadius = indicatorView.bounds.width / 2
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
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
    
    // MARK: Populate
    private func setEmpty() {
        thumbnailImageView.image = nil
        nameLabel.text = "kuStudy.NoData".localized()
        availablePlaceholderLabel.text = "kuStudy.Available".localized()
        totalPlaceholderLabel.text = "kuStudy.Total".localized()
        usedPlaceholderLabel.text = "kuStudy.Used".localized()
        availableLabel.text = "kuStudy.NoData".localized()
        totalLabel.text = "kuStudy.NoData".localized()
        usedLabel.text = "kuStudy.NoData".localized()
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
        
        thumbnailImageView.image = library.thumbnail
        indicatorView.backgroundColor = library.availablePercentageColor
    }
}
