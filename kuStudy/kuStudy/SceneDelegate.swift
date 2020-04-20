//
//  SceneDelegate.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/11.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import os.log

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        os_log(.debug, log: .default, "Scene will connect")
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = MainSplitViewController()
        
        // State restoration
        if let userActivity = connectionOptions.userActivities.first ?? scene.session.stateRestorationActivity {
            window?.rootViewController?.restoreUserActivityState(userActivity)
        }
        
        window?.makeKeyAndVisible()
    }
    
    // MARK: - State restoration
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
}

// MARK: - Quick action
extension SceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        os_log(.debug, log: .default, "Perform quick action %{PRIVATE}@", shortcutItem.type)
        
        switch shortcutItem.type {
        case "com.gbmksquare.kuapps.kuStudy.StudyAreaWeb":
            window?.rootViewController?.presentWebpage(url: URL.studyAreaURL)
        case "com.gbmksquare.kuapps.kuStudy.LibraryWeb":
            window?.rootViewController?.presentWebpage(url: URL.libraryURL)
        case "com.gbmksquare.kuapps.kuStudy.AcademicCalendarWeb":
            window?.rootViewController?.presentWebpage(url: URL.academicCalendarURL)
        case "com.gbmksquare.kuapps.kuStudy.LibraryView":
            guard let identifier = shortcutItem.userInfo?[NSUserActivity.Key.libraryIdentifier.name] as? String,
                let libraryType = LibraryType(rawValue: identifier) else {
                    os_log(.error, log: .default, "Failed to perform quick action")
                    return
            }
            let activity = NSUserActivity.libraryType(libraryType)
            window?.rootViewController?.restoreUserActivityState(activity)
        default:
            break
        }
        completionHandler(true)
    }
}

// MARK: - Handoff
extension SceneDelegate {
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        window?.rootViewController?.restoreUserActivityState(userActivity)
    }
}

// MARK: - URL
extension SceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            guard context.url.scheme == "kustudy" else { return }
            guard let identifier = context.url.query?.split(separator: "=").last?.map(String.init).first else { return }
            guard let libraryType = LibraryType(rawValue: identifier) else { return }
            let activity = NSUserActivity.libraryType(libraryType)
            window?.rootViewController?.restoreUserActivityState(activity)
        }
    }
}
