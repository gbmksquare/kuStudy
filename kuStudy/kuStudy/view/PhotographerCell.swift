//
//  PhotographerCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 14..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import SafariServices

class PhotographerCell: UICollectionViewCell {
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var associationLabel: UILabel!
    
    @IBOutlet weak var photographerStackView: UIStackView!
    
    private var artist: Artist?
    private var media: [Media]? {
        if let artist = artist {
            return MediaManager.shared.media(by: artist)
        } else {
            return nil
        }
    }
    
    private var currentPhotoIndex = 0
    private var timer: Timer?
    
    weak var presentingViewController: ThanksToViewController?
    
    // MARK: - View
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        wrapperView.layer.cornerRadius = 13
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 9
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.2
        
        [nameLabel, associationLabel].forEach {
            $0?.layer.shadowColor = UIColor.black.cgColor
            $0?.layer.shadowRadius = 6
            $0?.layer.shadowOpacity = 0.85
            $0?.layer.shadowOffset = CGSize(width: 1, height: 1)
        }
        
        photoImageView.accessibilityIgnoresInvertColors = true
        nameLabel.accessibilityIgnoresInvertColors = true
        associationLabel.accessibilityIgnoresInvertColors = true
    }
    
    // MARK: Popuplate
    override func prepareForReuse() {
        currentPhotoIndex = 0
        timer?.invalidate()
        timer = nil
        
        photoImageView.image = nil
        nameLabel.text = nil
        associationLabel.text = nil
    }
    
    func populate(_ artist: Artist) {
        self.artist = artist
        
        if let medium = media?.first {
            photoImageView.image = medium.image
            
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateImage(_:)), userInfo: nil, repeats: true)
        }
        
        nameLabel.text = artist.name
        associationLabel.text = artist.association
    }
    
    @objc private func updateImage(_ sender: Timer) {
        guard let media = media else { return }
        currentPhotoIndex += 1
        if currentPhotoIndex >= media.count {
            currentPhotoIndex = 0
        }
        let photo = media[currentPhotoIndex]
        UIView.transition(with: photoImageView, duration: 0.75, options: .transitionCrossDissolve,
          animations: { [weak self] in
            self?.photoImageView.image = photo.image
        }, completion: nil)
    }
}
