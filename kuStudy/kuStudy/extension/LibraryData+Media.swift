//
//  LibraryData+Media.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 8. 13..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import Foundation
import kuStudyKit

extension LibraryData {
    var media: Media? {
        guard let libraryType = libraryType else { return nil }
        return MediaManager.shared.preferredMedia(for: libraryType)
    }
}
