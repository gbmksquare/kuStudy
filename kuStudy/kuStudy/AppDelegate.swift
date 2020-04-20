
//
//  AppDelegate.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 30..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import AlamofireNetworkActivityIndicator
import FTLinearActivityIndicator
import SnapKit
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    // MARK: - Application
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        os_log(.debug, log: .default, "Application did launch")
        setupApplication()
        setupAppearance()
        listenForPreferenceChange()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        os_log(.debug, log: .default, "Configuration for session")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

// MARK: - Setup
extension AppDelegate {
    private func setupApplication() {
        Preference.shared.setup()
        updateQuickActions()
        NetworkActivityIndicatorManager.shared.isEnabled = true
        UIApplication.configureLinearNetworkActivityIndicatorIfNeeded()
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = .appPrimary
        UITabBar.appearance().tintColor = .appPrimary
        
        let components = Calendar.current.dateComponents([.month, .day], from: Date())
        if components.month == 4 && components.day == 1 {
            UINavigationBar.appearance().tintColor = .appAprilFoolsPrimary
            UITabBar.appearance().tintColor = .appAprilFoolsPrimary
        }
    }
}

// MARK: - Quick action
extension AppDelegate {
    private func listenForPreferenceChange() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(preferenceChanged:)),
                                               name: UserDefaults.didChangeNotification,
                                               object: nil)
    }
    
    // MARK: - Notification
    @objc
    private func handle(preferenceChanged notification: Notification) {
        updateQuickActions()
    }
    
    func updateQuickActions() {
        let orderedLibraryIds = Preference.shared.libraryOrder
        let libraryTypes = LibraryType.all
        
        let actionType = "com.gbmksquare.kuapps.kuStudy.LibraryView"
        let icon = UIApplicationShortcutIcon(systemImageName: "mappin.and.ellipse")
        let libraryType = libraryTypes.first { $0.identifier == orderedLibraryIds.first! }!
        let item = UIMutableApplicationShortcutItem(type: actionType,
                                                    localizedTitle: libraryType.name,
                                                    localizedSubtitle: nil,
                                                    icon: icon,
                                                    userInfo: [NSUserActivity.Key.libraryIdentifier.name: libraryType.identifier as NSSecureCoding])
        UIApplication.shared.shortcutItems = [item]
    }
}
