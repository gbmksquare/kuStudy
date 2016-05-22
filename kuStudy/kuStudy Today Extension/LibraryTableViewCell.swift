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
    @IBOutlet weak var libraryImageView: RingImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    
    // MARK: Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        libraryImageView.layer.cornerRadius = libraryImageView.bounds.width / 2
    }
    
    // MARK: Populate
    func populate(libraryData: LibraryData) {
        guard let libraryId = libraryData.libraryId else { return }
        let libraryType = LibraryType(rawValue: libraryId)
        nameLabel.text = libraryType?.name
        availableLabel.text = libraryData.availableSeats?.readableFormat
        
        libraryImageView.ringColor = libraryData.usedPercentageColor
        libraryImageView.rating = libraryData.usedPercentage
        libraryImageView.image = libraryData.thumbnail
    }
}
