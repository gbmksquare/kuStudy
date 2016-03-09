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
    func populate(library: Library) {
        nameLabel.text = library.name
        availableLabel.text = library.availableString
        
        libraryImageView.ringColor = library.usedPercentageColor
        libraryImageView.rating = library.usedPercentage
        libraryImageView.image = library.photo?.image
    }
}
