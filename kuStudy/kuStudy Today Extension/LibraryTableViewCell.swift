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
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var percentageView: CircularProgressView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    
    // MARK: Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        percentageView.progressBackgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.95, alpha: 1)
    }
    
    // MARK: Populate
    func populate(libraryData: LibraryData) {
        guard let libraryId = libraryData.libraryId else { return }
        
        let libraryType = LibraryType(rawValue: libraryId)
        nameLabel.text = libraryType?.name
        availableLabel.text = libraryData.availableSeats.readableFormat + " " + "kuStudy.Available".localized()
        
        thumbnailImageView.image = libraryData.thumbnail
        percentageView.progress = libraryData.availablePercentage
        percentageView.progressColor = libraryData.availablePercentageColor
    }
}
