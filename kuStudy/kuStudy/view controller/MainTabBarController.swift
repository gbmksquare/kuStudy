//
//  MainTabBarController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 1. 25..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.theme
        tabBar.items?.forEach {
            switch $0.tag {
            case 1: $0.title = Localizations.Main.Title.Library
            case 2: $0.title = Localizations.Main.Title.Preference
            default: break
            }
        }
        
        let settings = UINavigationController(rootViewController: SettingsViewController())
        settings.tabBarItem = UITabBarItem(title: Localizations.Main.Title.Preference, image: #imageLiteral(resourceName: "glyphicons-138-cogwheels"), tag: 3)
        viewControllers?.append(settings)
    }
}
