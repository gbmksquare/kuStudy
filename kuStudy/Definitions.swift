//
//  Definitions.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import UIKit

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

var sharedContainerUrl: NSURL? {
    return NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(kuStudySharedContainer)
}

// MARK: WatchKit
let kuStudyWatchKitRequestKey = "request"
let kuStudyWatchKitRequestSummary = "summary"
let kuStudyWatchKitRequestLibrary = "library"
let kuStudyWatchKitRequestLibraryKey = "libraryId"

// MARK: Handoff
let kuStudyHandoffSummary = "com.gbmksquare.kuapps.kuStudy.summaryView"
let kuStudyHandoffSummaryKey = "kuStudyHandoffSummaryKey"
let kuStudyHandoffLibrary = "com.gbmksquare.kuapps.kuStudy.libraryView"
let kuStudyHandoffLibraryIdKey = "kuStudyHandoffLibraryIdKey"

// MARK: Color
let kuStudyColorError = UIColor(hue:0.01, saturation:0.74, brightness:0.94, alpha:1)
let kuStudyColorWarning = UIColor(hue:0.09, saturation:0.82, brightness:0.99, alpha:1)
let kuStudyColorLightWarning = UIColor(hue:0.12, saturation:0.79, brightness:0.99, alpha:1)
let kuStudyColorConfirm = UIColor(hue:0.34, saturation:0.52, brightness:0.68, alpha:1)
let kuStudyGradientColor = [UIColor(red: 48/255, green: 35/255, blue: 174/255, alpha: 1).CGColor, UIColor(red: 109/255, green: 170/255, blue: 215/255, alpha: 1).CGColor]
