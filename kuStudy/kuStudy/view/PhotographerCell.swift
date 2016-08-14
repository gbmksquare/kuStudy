//
//  PhotographerCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 14..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class PhotographerCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var associationLabel: UILabel!
    @IBOutlet weak var instagramButton: UIButton!
    
    private var photographer: Photographer?
    private var currentPhotoIndex = 0
    private var timer: NSTimer?
    
    // MARK: Action
    @IBAction func tappedInstagramButton(sender: UIButton) {
        guard let instagramId = photographer?.instagramId else { return }
        
        let instagramAppUrl = NSURL(string: "instagram://user?username=\(instagramId)")!
        let instagramUrl = NSURL(string: "https://instagram.com/\(instagramId)")!
        
        let application = UIApplication.sharedApplication()
        if application.canOpenURL(instagramAppUrl) {
            application.openURL(instagramAppUrl)
        } else {
            application.openURL(instagramUrl)
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
        instagramButton.setTitle("", forState: .Normal)
    }
    
    func populate(photographer: Photographer) {
        self.photographer = photographer
        
        if let photo = photographer.photos.first {
            photoImageView.image = photo.image
            
            timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(updateImage(_:)), userInfo: nil, repeats: true)
        }
        
        if NSLocale.preferredLanguages().first?.hasPrefix("ko") == true {
            nameLabel.text = photographer.name
            associationLabel.text = photographer.association
        } else {
            nameLabel.text = photographer.name_en
            associationLabel.text = photographer.association_en
        }
        if photographer.instagramId.characters.count > 0 {
            instagramButton.setTitle("@" + photographer.instagramId, forState: .Normal)
        } else {
            instagramButton.setTitle("", forState: .Normal)
        }
    }
    
    @objc private func updateImage(sender: NSTimer) {
        guard let photos = photographer?.photos else { return }
        currentPhotoIndex += 1
        if currentPhotoIndex >= photos.count {
            currentPhotoIndex = 0
        }
        let photo = photos[currentPhotoIndex]
        UIView.transitionWithView(photoImageView, duration: 0.75, options: .TransitionCrossDissolve,
          animations: { [weak self] in
            self?.photoImageView.image = photo.image
        }, completion: nil)
    }
}
