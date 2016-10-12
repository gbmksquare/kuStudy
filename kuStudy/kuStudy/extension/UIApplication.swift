//
//  UIApplication.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 6..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

extension UIApplication {
    static var versionString: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        return "\(version) (\(build))"
    }
}
