//
//  Definitions.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation

// MARK: Shared container
let kuStudySharedContainer = "group.com.gbmksquare.kuapps.kuStudy"

var sharedContainerUrl: URL? {
    return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kuStudySharedContainer)
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
