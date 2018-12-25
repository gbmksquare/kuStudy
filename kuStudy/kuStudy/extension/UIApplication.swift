//
//  UIApplication.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 6..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

extension UIApplication {
    var applicationName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
    
    var versionString: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        #if DEBUG
            return "\(version) (\(build)) Debug"
        #else
            return "\(version) (\(build))"
        #endif
    }
    
    var isSplitViewOrSliderOver: Bool {
        guard let w = delegate?.window, let window = w else { return false }
        return window.frame.width == window.screen.bounds.width ? false : true
    }
}
