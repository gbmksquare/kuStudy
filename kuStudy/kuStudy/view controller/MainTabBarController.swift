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
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
//        let library = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SummaryViewController"))
        let library = UINavigationController(rootViewController: SummaryViewController())
        let libraryItem = UITabBarItem(title: Localizations.Title.Library, image: #imageLiteral(resourceName: "187-pencil"), tag: 1)
        libraryItem.accessibilityIdentifier = "Tab 0"
        library.tabBarItem = libraryItem
        
        let settings = UINavigationController(rootViewController: SettingsViewController())
        let settingsItem = UITabBarItem(title: Localizations.Title.Settings, image: #imageLiteral(resourceName: "glyphicons-138-cogwheels"), tag: 2)
        settingsItem.accessibilityIdentifier = "Tab 1"
        settings.tabBarItem = settingsItem
        
        viewControllers = [library, settings]
    }
}
