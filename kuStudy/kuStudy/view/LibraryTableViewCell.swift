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
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var availableDataLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!

    // MARK: View
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        indicatorView.layer.cornerRadius = indicatorView.bounds.width / 2
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        availableLabel.text = "kuStudy.Available".localized()
    }
    
    // MARK: Populate
    private func setEmpty() {
        thumbnailImageView.image = nil
        nameLabel.text = "--"
        availableDataLabel.text = "--"
        totalLabel.text = "kuStudy.Total".localized() + ": --"
        usedLabel.text = "kuStudy.Used".localized() + ": --"
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
        availableDataLabel.text =  library.availableSeats.readable
        totalLabel.text = "kuStudy.Total".localized() + ": " + library.totalSeats.readable
        usedLabel.text = "kuStudy.Used".localized() + ": " + library.usedSeats.readable
        
        thumbnailImageView.image = library.thumbnail
        indicatorView.backgroundColor = library.availablePercentageColor
    }
}
