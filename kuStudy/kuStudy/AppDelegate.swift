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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: Action
    private func handleFirstRun() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("isFirstRun") == true {
            defaults.setBool(false, forKey: "isFirstRun")
        }
    }
    
    private func setupFabric() {
        #if DEBUG
        #else
            Fabric.with([Crashlytics()])
        #endif
    }
    
    private func registerDefaultPreferences() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.registerDefaults(["libraryOrder": [1, 2, 3, 4, 5]])
        defaults.synchronize()
    }
    
    private func customizeAppearance() {
        UINavigationBar.appearance().barStyle = UIBarStyle.Black
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    }
    
    // MARK: Application
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupFabric()
        handleFirstRun()
        registerDefaultPreferences()
        customizeAppearance()
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
    
    // MARK: Handoff
    func application(application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        print(userActivityType)
        return false
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        if let window = window {
            let navigationController = window.rootViewController as! UINavigationController
            let summaryViewController = navigationController.topViewController as! SummaryViewController
            summaryViewController.restoreUserActivityState(userActivity)
        }
        return true
    }
}

