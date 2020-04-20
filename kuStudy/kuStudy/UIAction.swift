//
//  UIAction.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/14.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import os.log

extension UIAction {
    static func copy(string: String) -> UIAction {
        UIAction(title: "copy".localized(),
                 image: UIImage(systemName: "doc.on.doc")) {_ in
                    UIPasteboard.general.string = string
        }
    }
    
    static func share(string: String,
                      presentOn viewController: UIViewController?,
                      sourceView: UIView? = nil,
                      barButtonItem: UIBarButtonItem? = nil) -> UIAction {
        UIAction(title: "share".localized(),
                 image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    viewController?.presentShareSheet(activityItems: [string],
                                                      applicationActivities: nil,
                                                      sourceView: sourceView,
                                                      barButtonItem: barButtonItem)
        }
    }
    
    static func maps(title: String,
                     _ handler: @escaping (UIAction) -> Void) -> UIAction {
        UIAction(title: title,
                 image: UIImage(systemName: "map"),
                 handler: handler)
    }
    
    static func presentWebpage(url: URL,
                               openInApp: Bool,
                               on viewController: UIViewController?) -> UIAction {
        let title = openInApp ? "openWebInApp".localized() : "openWeb".localized()
        return UIAction(title: title,
                        image: UIImage(systemName: "safari"))
        { (_) in
            if openInApp {
                viewController?.presentWebpage(url: url)
            } else {
                if UIApplication.shared.canOpenURL(url) == true {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    os_log(.error, log: .default, "Failed to open URL")
                }
            }
        }
    }
}
