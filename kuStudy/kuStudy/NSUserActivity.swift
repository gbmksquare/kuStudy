//
//  NSUserActivity.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/14.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
#if os(iOS)
import kuStudyKit
#elseif os(watchOS)
import kuStudyWatchKit
#endif

extension NSUserActivity {
    enum ActivityType: String {
        case summary = "com.gbmksquare.kuapps.kuStudy.handoff.summary"
        case library = "com.gbmksquare.kuapps.kuStudy.handoff.library"
        case studyArea = "com.gbmksquare.kuapps.kuStudy.handoff.studyArea"
    }
    
    enum Key: String {
        case libraryIdentifier
        case studyAreaIdentifier
        
        var name: String { rawValue }
    }
    
    // MARK: - Initialization
    static func summary(_ data: Summary) -> NSUserActivity {
        let activity = NSUserActivity(activityType: NSUserActivity.ActivityType.summary.rawValue)
        activity.title = "studyArea".localizedFromKit()
        return activity
    }
    
    static func library(_ data: Library) -> NSUserActivity {
        let activity = NSUserActivity(activityType: NSUserActivity.ActivityType.library.rawValue)
        activity.title = data.name
        activity.addUserInfoEntries(from: [Key.libraryIdentifier.name: data.type.identifier])
        return activity
    }
    
    static func libraryType(_ type: LibraryType) -> NSUserActivity {
        let activity = NSUserActivity(activityType: NSUserActivity.ActivityType.library.rawValue)
        activity.title = type.name
        activity.addUserInfoEntries(from: [Key.libraryIdentifier.name: type.identifier])
        return activity
    }
    
    static func studyArea(_ data: StudyArea, libraryType: LibraryType) -> NSUserActivity {
        let activity = NSUserActivity(activityType: NSUserActivity.ActivityType.studyArea.rawValue)
        activity.title = data.name
        activity.addUserInfoEntries(from: [Key.libraryIdentifier.name: libraryType.identifier])
        activity.addUserInfoEntries(from: [Key.studyAreaIdentifier.name: data.identifier])
        return activity
    }
}
