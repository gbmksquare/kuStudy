
//
//  AppDelegate.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 30..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import Fabric
import Crashlytics
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupFabric()
        registerDefaultPreferences()
        customizeAppearance()
        listenForUserDefaultsDidChange()
        NetworkActivityIndicatorManager.sharedManager.isEnabled = true
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// MARK: Setup
extension AppDelegate {
    private func setupFabric() {
        #if DEBUG
        #else
            Fabric.with([Crashlytics()])
        #endif
    }
    
    private func registerDefaultPreferences() {
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
        defaults.registerDefaults(["libraryOrder": libraryOrder,
            "todayExtensionOrder": libraryOrder,
            "todayExtensionHidden": []])
        defaults.synchronize()
        updateQuickActionItems()
    }
    
    private func customizeAppearance() {
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().barTintColor = UIColor.themeColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
    }
}

// MARK: Url
extension AppDelegate {
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        guard let window = window else { return false }
        
        let tabBarController = window.rootViewController as! MainTabBarController
        tabBarController.selectedIndex = 0
        
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        navigationController.popToRootViewControllerAnimated(false)
        let summaryViewController = navigationController.topViewController as! SummaryViewController
        
        let userActivity = NSUserActivity(activityType: kuStudyHandoffLibrary)
        guard let libraryId = url.query?.characters.split("=").last.map(String.init) else { return false }
        userActivity.addUserInfoEntriesFromDictionary(["libraryId": libraryId])
        summaryViewController.restoreUserActivityState(userActivity)
        return true
    }
}

// MARK: Handoff
extension AppDelegate {
    func application(application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        guard let window = window else { return false }
        guard let tabBarController = window.rootViewController as? MainTabBarController else { return false }
        tabBarController.selectedIndex = 0
        
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        navigationController.popToRootViewControllerAnimated(false)
        let summaryViewController = navigationController.topViewController as! SummaryViewController
        summaryViewController.restoreUserActivityState(userActivity)
        
        return true
    }
}

// MARK: Quick action
extension AppDelegate {
    private func listenForUserDefaultsDidChange() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleUserDefaultsDidChange(_:)), name: NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    @objc private func handleUserDefaultsDidChange(notification: NSNotification) {
        updateQuickActionItems()
    }
    
    private func updateQuickActionItems() {
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        let orderedLibraryIds = defaults.arrayForKey("libraryOrder") as! [String]
        let libraryTypes = LibraryType.allTypes()
        
        let actionType = "com.gbmksquare.kuapps.kucourse.LibraryAction"

        let icon = UIApplicationShortcutIcon(templateImageName: "glyphicons-352-book-open")
        var quickActionItems = [UIMutableApplicationShortcutItem]()
        for libraryId in orderedLibraryIds {
            let libraryType = libraryTypes.filter({ $0.rawValue == libraryId }).first!
            let item = UIMutableApplicationShortcutItem(type: actionType, localizedTitle: libraryType.name, localizedSubtitle: nil, icon: icon, userInfo: ["libraryId": libraryId])
            quickActionItems.append(item)
        }
        
        UIApplication.sharedApplication().shortcutItems = quickActionItems
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        guard let window = window else { return }
        
        let tabBarController = window.rootViewController as! MainTabBarController
        tabBarController.selectedIndex = 0
        
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        navigationController.popToRootViewControllerAnimated(false)
        let summaryViewController = navigationController.topViewController as! SummaryViewController
        
        switch shortcutItem.type {
        case "com.gbmksquare.kuapps.kucourse.LibraryAction":
            let userActivity = NSUserActivity(activityType: kuStudyHandoffLibrary)
            let libraryId = shortcutItem.userInfo!["libraryId"] as! String
            userActivity.addUserInfoEntriesFromDictionary(["libraryId": libraryId])
            summaryViewController.restoreUserActivityState(userActivity)
        default: break
        }
    }
}
