//
//  UINavigationController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 6..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

extension UINavigationController {
    func setTransparent() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
    }
}
