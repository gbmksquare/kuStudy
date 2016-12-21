//
//  TodayViewControllerPreference.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 10. 12..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

extension TodayViewController {
    func registerPreference() {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
        defaults.register(defaults: ["libraryOrder": libraryOrder,
                                     "todayExtensionOrder": libraryOrder,
                                     "todayExtensionHidden": []])
        defaults.synchronize()
    }
    
    func listenToPreferenceChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(handle(preferenceChanged:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc func handle(preferenceChanged notification: Notification) {
        updateView()
    }
}
