
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
import SimulatorStatusMagic

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupFabric()
        registerDefaultPreferences()
        customizeAppearance()
        setupStatusbarForSnapshot()
        listenForUserDefaultsDidChange()
        NetworkActivityIndicatorManager.shared.isEnabled = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Url
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        guard let window = window else { return false }
        
        let splitViewController = window.rootViewController as! MainSplitViewController
        let tabBarController = splitViewController.childViewControllers.first as! MainTabBarController
        tabBarController.selectedIndex = 0
        
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        navigationController.popToRootViewController(animated: false)
        let summaryViewController = navigationController.topViewController as! SummaryViewController
        
        let userActivity = NSUserActivity(activityType: kuStudyHandoffLibrary)
        guard let libraryId = url.query?.characters.split(separator: "=").last.map(String.init) else { return false }
        userActivity.addUserInfoEntries(from: ["libraryId": libraryId])
        summaryViewController.restoreUserActivityState(userActivity)
        return true
    }
    
    // MARK: Handoff
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let window = window else { return false }
        let splitViewController = window.rootViewController as! MainSplitViewController
        let tabBarController = splitViewController.childViewControllers.first as! MainTabBarController
        tabBarController.selectedIndex = 0
        
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        navigationController.popToRootViewController(animated: false)
        let summaryViewController = navigationController.topViewController as! SummaryViewController
        summaryViewController.restoreUserActivityState(userActivity)
        
        return true
    }
    
    // MARK: Quick action
    fileprivate func listenForUserDefaultsDidChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDefaultsDidChange(_:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc fileprivate func handleUserDefaultsDidChange(_ notification: Notification) {
        updateQuickActionItems()
    }
    
    fileprivate func updateQuickActionItems() {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        let orderedLibraryIds = defaults.array(forKey: "libraryOrder") as! [String]
        let libraryTypes = LibraryType.allTypes()
        
        let actionType = "com.gbmksquare.kuapps.kucourse.LibraryAction"
        
        let icon = UIApplicationShortcutIcon(templateImageName: "187-pencil")
        var quickActionItems = [UIMutableApplicationShortcutItem]()
        for libraryId in orderedLibraryIds {
            let libraryType = libraryTypes.filter({ $0.rawValue == libraryId }).first!
            let item = UIMutableApplicationShortcutItem(type: actionType, localizedTitle: libraryType.name, localizedSubtitle: nil, icon: icon, userInfo: ["libraryId": libraryId])
            quickActionItems.append(item)
        }
        
        UIApplication.shared.shortcutItems = quickActionItems
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let window = window else { return }
        
        let splitViewController = window.rootViewController as! MainSplitViewController
        let tabBarController = splitViewController.childViewControllers.first as! MainTabBarController
        tabBarController.selectedIndex = 0
        
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        navigationController.popToRootViewController(animated: false)
        let summaryViewController = navigationController.topViewController as! SummaryViewController
        
        switch shortcutItem.type {
        case "com.gbmksquare.kuapps.kucourse.LibraryAction":
            let userActivity = NSUserActivity(activityType: kuStudyHandoffLibrary)
            let libraryId = shortcutItem.userInfo!["libraryId"] as! String
            userActivity.addUserInfoEntries(from: ["libraryId": libraryId])
            summaryViewController.restoreUserActivityState(userActivity)
        default: break
        }
    }
}

// MARK: Setup
extension AppDelegate {
    fileprivate func setupFabric() {
        #if DEBUG
//            Fabric.with([Crashlytics()])
        #else
            Fabric.with([Crashlytics()])
        #endif
    }
    
    fileprivate func registerDefaultPreferences() {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
        defaults.register(defaults: ["libraryOrder": libraryOrder,
            "todayExtensionOrder": libraryOrder,
            "todayExtensionHidden": []])
        defaults.synchronize()
        updateQuickActionItems()
    }
    
    fileprivate func customizeAppearance() {
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().barTintColor = UIColor.theme
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().tintColor = UIColor.white
    }
    
    fileprivate func setupStatusbarForSnapshot() {
        if UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
            guard NSClassFromString("SDStatusBarManager") != nil else { return }
            SDStatusBarManager.sharedInstance().enableOverrides()
        }
    }
}
