//
//  MainTabBarController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 1. 25..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTabBarAppearance()
    }
    
    private func customizeTabBarAppearance() {
        // Bar
        tabBar.tintColor = UIColor.navigationColor()
    }
}
