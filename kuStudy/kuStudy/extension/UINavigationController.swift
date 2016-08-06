//
//  UINavigationController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 6..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

extension UINavigationController {
    func setTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.translucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clearColor()
        view.backgroundColor = UIColor.clearColor()
    }
}
