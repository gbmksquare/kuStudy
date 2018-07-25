//
//  UIWindow.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 7. 25..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import UIKit

import UIKit

extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
