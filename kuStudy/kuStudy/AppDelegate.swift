//
//  AppDelegate.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 30..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: Action
    private func handleFirstRun() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("isFirstRun") == true {
            // TODO: Should also run when database is missing, not just first run
            fetchLibraryInfoKey()
            
            defaults.setBool(false, forKey: "isFirstRun")
        }
    }
    
    private func setupKuStudy() {
        let studyKit = kuStudy()
        studyKit.setAuthentification(kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
    }
    
    private func fetchLibraryInfoKey() {
        kuStudy().requestInfo { (json, error) -> Void in
            if let json = json {
                let libraries = json["content"]["libraries"].arrayValue
                let readingRooms = json["content"]["readingRooms"].arrayValue
                
                var libraryInfoRecords = [LibraryInfoRecord]()
                for library in libraries {
                    let record = LibraryInfoRecord()
                    record.id = library["id"].intValue
                    record.key = library["key"].stringValue
                    libraryInfoRecords.append(record)
                }
                for readingRoom in readingRooms {
                    let record = LibraryInfoRecord()
                    record.id = readingRoom["id"].intValue
                    record.key = readingRoom["key"].stringValue
                    libraryInfoRecords.append(record)
                }
                let infoRealm = kuStudy.infoRealm()
                for record in libraryInfoRecords {
                    infoRealm.write({ () -> Void in
                        infoRealm.add(record, update: true)
                    })
                }
            } else {
                // TODO: Handle error
            }
        }
    }
    
    // MARK: Application
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupKuStudy()
        handleFirstRun()
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

