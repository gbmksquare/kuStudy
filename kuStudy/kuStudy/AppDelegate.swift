
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
import FTLinearActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - Application
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupApplication()
        
        let splitViewController = MainSplitViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - Url
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        guard let window = window else { return false }
        
        let splitViewController = window.rootViewController as! MainSplitViewController
        let tabBarController = splitViewController.children.first as! MainTabBarController
        tabBarController.selectedIndex = 0
        
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        navigationController.popToRootViewController(animated: false)
        let summaryViewController = navigationController.topViewController as! SummaryViewController
        
        let userActivity = NSUserActivity(activityType: kuStudyHandoffLibrary)
        guard let libraryId = url.query?.split(separator: "=").last.map(String.init) else { return false }
        userActivity.addUserInfoEntries(from: ["libraryId": libraryId])
        summaryViewController.restoreUserActivityState(userActivity)
        return true
    }
    
    // MARK: - Handoff
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let window = window else { return false }
        let splitViewController = window.rootViewController as! MainSplitViewController
        let tabBarController = splitViewController.children.first as! MainTabBarController
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
        let tabBarController = splitViewController.children.first as! MainTabBarController
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
    private func setupApplication() {
        Preference.shared.setup()
        setupAppearance()
        setupFabric()
        NetworkActivityIndicatorManager.shared.isEnabled = true
        UIApplication.configureLinearNetworkActivityIndicatorIfNeeded()
    }
    
    private func setupFabric() {
        #if !DEBUG
            Fabric.with([Crashlytics()])
            let device = UIDevice.current
            let data: [String: Any] = ["Device": device.model,
                                       "Model": device.modelIdentifier,
                                       "OS": device.systemName + " " + device.systemVersion,
                                       "Version": UIApplication.shared.versionString,
                                       "VoiceOver": UIAccessibility.isVoiceOverRunning,
                                       "BoldText": UIAccessibility.isBoldTextEnabled,
                                       "ReduceTransparency": UIAccessibility.isReduceTransparencyEnabled,
                                       "ReduceMotion": UIAccessibility.isReduceMotionEnabled,
                                       "Grayscale": UIAccessibility.isGrayscaleEnabled,
                                       "InvertColor": UIAccessibility.isInvertColorsEnabled,
                                       "MonoAudio": UIAccessibility.isMonoAudioEnabled,
                                       "ShakeToUndo": UIAccessibility.isShakeToUndoEnabled,
                                       "SpeakScreen": UIAccessibility.isSpeakScreenEnabled,
                                       "SpeakSelection": UIAccessibility.isSpeakSelectionEnabled,
                                       "GuidedAccess": UIAccessibility.isGuidedAccessEnabled,
                                       "SwitchControl": UIAccessibility.isSwitchControlRunning,
                                       "AssistiveTouch": UIAccessibility.isAssistiveTouchRunning]
            Answers.logCustomEvent(withName: "Launch", customAttributes: data)
        #endif
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().barTintColor = .theme
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        UITabBar.appearance().tintColor = .theme
    }
}
