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


import UIKit


enum AppPreference {
    static let cornerRadius: CGFloat = 13
}


