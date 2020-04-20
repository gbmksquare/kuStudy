//
//  UIViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/07.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentShareSheet(activityItems: [Any], applicationActivities: [UIActivity]?, sourceView: UIView? = nil, barButtonItem: UIBarButtonItem? = nil) {
        let shareSheet = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: applicationActivities)
        shareSheet.popoverPresentationController?.sourceView = sourceView
        shareSheet.popoverPresentationController?.barButtonItem = barButtonItem
        present(shareSheet, animated: true)
    }
    
    func presentWebpage(url: URL) {
        let safari = kuAppsSafariViewController(url: url)
        present(safari, animated: true)
    }
}
