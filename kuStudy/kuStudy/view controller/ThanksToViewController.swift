//
//  ThanksToViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 6. 26..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import SafariServices

class ThanksToViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var photographers: [Photographer] {
        return PhotoProvider.sharedProvider.photographers
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Collection view
extension ThanksToViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        
        if traitCollection.horizontalSizeClass == .compact {
            width = collectionView.bounds.width
        } else if traitCollection.preferredContentSizeCategory == .accessibilityLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraExtraLarge {
            width = collectionView.bounds.width
        } else {
            width = (collectionView.bounds.width - 10) / 2
        }
        
        if traitCollection.preferredContentSizeCategory == .accessibilityExtraLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraExtraLarge {
            height = 480
        } else {
            height = 260
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photographer = photographers[indexPath.row]
        presentInstagram(id: photographer.instagramId)
    }
    
    // Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photographers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photographer = photographers[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotographerCell
        cell.populate(photographer)
        cell.presentingViewController = self
        return cell
    }
}

// MARK: - Instagram
extension ThanksToViewController {
    private func presentInstagram(id instagramId: String) {
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
        let alert = UIAlertController(title: Localizations.Settings.Thanksto.Instagram.Alert.Title, message: nil, preferredStyle: .alert)
        let open = UIAlertAction(title: Localizations.Alert.Action.Confirm, style: .default) { (_) in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        let cancel = UIAlertAction(title: Localizations.Alert.Action.Cancel, style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(open)
        present(alert, animated: true, completion: nil)
    }
    
    private func openInSafariViewController(_ url: URL) {
        let safari = SFSafariViewController(url: url)
        safari.preferredControlTintColor = UIColor.theme
        present(safari, animated: true, completion: nil)
    }
}
