//
//  kuAppsSafariViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 25/12/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import UIKit
import SafariServices

class kuAppsSafariViewController: SFSafariViewController {
    override init(url: URL, configuration: SFSafariViewController.Configuration) {
        super.init(url: url, configuration: configuration)
        preferredControlTintColor = UIColor.theme
        dismissButtonStyle = .close
        
        let components = Calendar.current.dateComponents([.month, .day], from: Date())
        if components.month == 4 && components.day == 1 {
            preferredControlTintColor = UIColor.themeAprilFools
        }
    }
    
    class func open(url: URL, entersReaderMode: Bool = false, alwaysInApp: Bool = true) -> kuAppsSafariViewController? {
        func openInApp() -> kuAppsSafariViewController {
            let configuration = SFSafariViewController.Configuration()
            configuration.entersReaderIfAvailable = entersReaderMode
            let safari = kuAppsSafariViewController(url: url, configuration: configuration)
            return safari
        }
        
        func openInSafari() {
            let app = UIApplication.shared
            if app.canOpenURL(url) {
                app.open(url, options: [:])
            }
        }
        
        return openInApp()
        // TODO: Disabled until find out a way to detect if Safari is running on split view
//        if alwaysInApp == false && UIApplication.shared.isSplitViewOrSliderOver == true {
//            openInSafari()
//            return nil
//        } else {
//            return openInApp()
//        }
    }
}
