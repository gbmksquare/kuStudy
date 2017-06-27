
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
#if DEBUG
import SimulatorStatusMagic
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - Application
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupApplication()
        return true
    }
    
    // MARK: - Url
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
    
    // MARK: - Handoff
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
    
    // MARK: - Quick action
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

// MARK: - Setup
extension AppDelegate {
    fileprivate func setupApplication() {
        Preference.shared.registerDefault()
        setupAppearance()
        setupStatusbarForSnapshot()
        setupFabric()
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
    
    private func setupFabric() {
        #if !DEBUG
            Fabric.with([Crashlytics()])
        #endif
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().barTintColor = UIColor.theme
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().tintColor = UIColor.white
    }
    
    private func setupStatusbarForSnapshot() {
        #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("Snapshot") ? true : false {
                SDStatusBarManager.sharedInstance().enableOverrides()
            }
        #endif
    }
}
