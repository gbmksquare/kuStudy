//
//  Extensions.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 1. 25..
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
