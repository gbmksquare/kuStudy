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
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var percentageView: CircularProgressView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!

    // MARK: Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        percentageView.progressBackgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.95, alpha: 1)
    }
    
    // MARK: Populate
    private func setEmpty() {
        thumbnailImageView.image = nil
        percentageView.progress = 0
        nameLabel.text = "--"
        availableLabel.text = "--"
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
        availableLabel.text = library.availableSeats.readable + " " + "kuStudy.Available".localized()
        
        thumbnailImageView.image = library.thumbnail
        percentageView.progress = library.availablePercentage
        percentageView.progressColor = library.availablePercentageColor
    }
}
