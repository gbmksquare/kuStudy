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
    @IBOutlet weak var libraryImageView: RingImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    
    // MARK: Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        libraryImageView.layer.cornerRadius = libraryImageView.bounds.width / 2
    }
    
    // MARK: Populate
    func populate(library: LibraryViewModel) {
        nameLabel.text = library.name
        availableLabel.text = library.availableString
        usedLabel.text = library.usedString
        
        libraryImageView.ringColor = library.usedPercentageColor
        libraryImageView.rating = library.usedPercentage
        if let imageName = library.imageName {
            libraryImageView.image = UIImage(named: imageName)
        }
    }
}
