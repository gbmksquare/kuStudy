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

class PhotographerCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var associationLabel: UILabel!
    @IBOutlet weak var instagramButton: UIButton!
    
    fileprivate var photographer: Photographer?
    fileprivate var currentPhotoIndex = 0
    fileprivate var timer: Timer?
    
    weak var presentingViewController: AcknowledgementViewController?
    
    // MARK: Action
    @IBAction func tappedInstagramButton(_ sender: UIButton) {
        guard let instagramId = photographer?.instagramId else { return }
        presentInstagram(id: instagramId)
    }
    
    // MARK: Popuplate
    override func prepareForReuse() {
        currentPhotoIndex = 0
        timer?.invalidate()
        timer = nil
        
        photoImageView.image = nil
        nameLabel.text = nil
        associationLabel.text = nil
        instagramButton.setTitle("", for: UIControlState())
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
        if photographer.instagramId.characters.count > 0 {
            instagramButton.setTitle("@" + photographer.instagramId, for: .normal)
        } else {
            instagramButton.setTitle("", for: UIControlState())
        }
    }
    
    @objc fileprivate func updateImage(_ sender: Timer) {
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

// MARK: - Action
extension PhotographerCell {
    fileprivate func presentInstagram(id instagramId: String) {
        guard let instagramAppUrl = URL(string: "instagram://user?username=\(instagramId)"),
            let instagramUrl = URL(string: "https://instagram.com/\(instagramId)") else { return }
        let application = UIApplication.shared
        if application.canOpenURL(instagramAppUrl) {
            openInInstagram(instagramAppUrl)
        } else {
            openInSafariViewController(instagramUrl)
        }
    }
    
    private func openInInstagram(_ url: URL) {
        let alert = UIAlertController(title: "kuStudy.Settings.ThanksTo.InstagramAlert.Title".localized(), message: nil, preferredStyle: .alert)
        let open = UIAlertAction(title: "kuStudy.Alert.Confirm".localized(), style: .default) { (_) in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        let cancel = UIAlertAction(title: "kuStudy.Alert.Cancel".localized(), style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(open)
        presentingViewController?.present(alert, animated: true, completion: nil)
    }
    
    private func openInSafariViewController(_ url: URL) {
        let safari = SFSafariViewController(url: url)
        safari.preferredControlTintColor = UIColor.theme
        presentingViewController?.present(safari, animated: true, completion: nil)
    }
}
