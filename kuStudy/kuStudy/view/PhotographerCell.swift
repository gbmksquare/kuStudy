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
    
    private var photographer: Photographer?
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
        
        if #available(iOS 11.0, *) {
            
        } else {
            photographerStackView.spacing = 4
            photographerStackView.isBaselineRelativeArrangement = false
        }
        
        [nameLabel, associationLabel].forEach {
            $0?.layer.shadowColor = UIColor.black.cgColor
            $0?.layer.shadowRadius = 6
            $0?.layer.shadowOpacity = 0.85
            $0?.layer.shadowOffset = CGSize(width: 1, height: 1)
        }
        
        if #available(iOS 11.0, *) {
            photoImageView.accessibilityIgnoresInvertColors = true
            nameLabel.accessibilityIgnoresInvertColors = true
            associationLabel.accessibilityIgnoresInvertColors = true
        }
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
    
    func populate(_ photographer: Photographer) {
        self.photographer = photographer
        
        if let photo = photographer.photos.first {
            photoImageView.image = photo.image
            
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateImage(_:)), userInfo: nil, repeats: true)
        }
        
        if Locale.preferredLanguages.first?.hasPrefix("ko") == true {
            nameLabel.text = photographer.name
            associationLabel.text = photographer.association
        } else {
            nameLabel.text = photographer.name_en
            associationLabel.text = photographer.association_en
        }
    }
    
    @objc private func updateImage(_ sender: Timer) {
        guard let photos = photographer?.photos else { return }
        currentPhotoIndex += 1
        if currentPhotoIndex >= photos.count {
            currentPhotoIndex = 0
        }
        let photo = photos[currentPhotoIndex]
        UIView.transition(with: photoImageView, duration: 0.75, options: .transitionCrossDissolve,
          animations: { [weak self] in
            self?.photoImageView.image = photo.image
        }, completion: nil)
    }
}
