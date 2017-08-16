//
//  NotificationCoordinator.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 8. 16..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import UserNotifications
import kuStudyKit

enum RemindInterval {
    case now
    case min15
    case min30
    case hour1
    case hour3
    case hour6
    case custom(TimeInterval)
    
    var seconds: TimeInterval {
        switch self {
        case .now: return 2
        case .min15: return 900
        case .min30: return 1800
        case .hour1: return 3600
        case .hour3: return 10800
        case .hour6: return 21600
        case .custom(let interval): return interval
        }
    }
}

class NotificationCoordinator: NSObject {
    static let shared = NotificationCoordinator()
    
    private var center: UNUserNotificationCenter {
        return UNUserNotificationCenter.current()
    }
    
    // MARK: - Initialization
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: - Authorization
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
        }
    }
    
    // MARK: - Notification
    func remind(library: LibraryType, fromNow interval: RemindInterval) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval.seconds, repeats: false)
        let content = notificationContent(for: library)
        
        let identifier = library.rawValue + String(Date().timeIntervalSince1970)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            
        }
    }
    
    func remind(library: LibraryType, at: Date) {
        
    }
    
    // MARK: - Content
    func notificationContent(for library: LibraryType) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = library.name
        content.subtitle = library.nameInAlternateLanguage
        content.body = Localizations.Notification.Content.Taptoshow
        content.sound = UNNotificationSound.default()
        content.userInfo = ["libraryId": library.rawValue]
        return content
    }
}

extension NotificationCoordinator: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard let window = UIApplication.shared.keyWindow else {
            completionHandler()
            return
        }
        let splitViewController = window.rootViewController as! MainSplitViewController
        let tabBarController = splitViewController.childViewControllers.first as! MainTabBarController
        tabBarController.selectedIndex = 0
        
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        navigationController.popToRootViewController(animated: false)
        let summaryViewController = navigationController.topViewController as! SummaryViewController
        let userActivity = NSUserActivity(activityType: kuStudyHandoffLibrary)
        let libraryId = response.notification.request.content.userInfo["libraryId"] as! String
        userActivity.addUserInfoEntries(from: ["libraryId": libraryId])
        summaryViewController.restoreUserActivityState(userActivity)
        
        completionHandler()
    }
}
