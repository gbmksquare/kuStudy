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
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        percentageView.progressBackgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.95, alpha: 1)
    }
    
    // MARK: Populate
    private func updateEmptyView() {
        thumbnailImageView.image = nil
        percentageView.progress = 0
        nameLabel.text = "--"
        availableLabel.text = "--"
    }
    
    func populate(libraryData: LibraryData?) {
        guard let libraryData = libraryData else {
            updateEmptyView()
            return
        }
        guard let libraryId = libraryData.libraryId, availableSeats = libraryData.availableSeats else {
            updateEmptyView()
            return
        }
        
        let libraryType = LibraryType(rawValue: libraryId)
        nameLabel.text = libraryType?.name
        availableLabel.text = availableSeats.readableFormat + " " + "kuStudy.Available".localized()
        
        thumbnailImageView.image = libraryData.thumbnail
        percentageView.progress = libraryData.usedPercentage
        percentageView.progressColor = libraryData.usedPercentageColor
    }
}
