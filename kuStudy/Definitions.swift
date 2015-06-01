//
//  Definitions.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation

// MARK: Authentification
let kuStudyAPIAccessId = "kustudy"
let kuStudyAPIAccessPassword = "leid*Eat.Oc:koR.I^Ho"

// MARK: Keychain
let kuStudyKeychainService = "com.gbmksquare.kuapps.kuStudy"
let kuStudyKeychainAccessGroup = "3ZTVE7CS5L.com.gbmksquare.kuapps.kuStudy"

let kuStudyKeychainIdKey = "kuStudyKeychainIdKey"
let kuStudyKeychainPasswordKey = "kuStudyKeychainPasswordKey"

// MARK: Shared container
let kuStudySharedContainer = "group.com.gbmksquare.kuapps.kuStudy"

var sharedContainerPath: String {
    return NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(kuStudySharedContainer)!.path!
}

// MARK: WatchKit
let kuStudyWatchKitRequestKey = "request"
let kuStudyWatchKitRequestSummary = "summary"
let kuStudyWatchKitRequestLibrary = "library"
let kuStudyWatchKitRequestLibraryKey = "libraryId"
