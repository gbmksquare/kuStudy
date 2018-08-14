//
//  MediaManagerTests.swift
//  kuStudyTests
//
//  Created by BumMo Koo on 2018. 8. 13..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import Foundation
import XCTest
@testable import kuStudy
@testable import kuStudyKit

class MediaManagerTests: XCTestCase {
    // MARK: - Setup
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test
    func testMainMedia() {
        let manager = MediaManager.shared
        for _ in 1...10 {
            let media = manager.mediaForMain()
            let image = media?.image
            XCTAssertNotNil(media)
            XCTAssertNotNil(image)
            manager.clearCache()
        }
    }
    
    func testPredefinedMedia() {
        let manager = MediaManager.shared
        for library in LibraryType.allTypes() {
            let media = manager.predefinedMedia(for: library)
            XCTAssertNotNil(media)
        }
    }
    
    func testFindMediaByLibraryPerformance1() {
        let library = LibraryType.allTypes().first!
        measure {
            let _ = MediaManager.shared.media(for: library)
        }
    }
    
    func testFindMediaByLibraryPerformance2() {
        let library = LibraryType.allTypes().last!
        measure {
            let _ = MediaManager.shared.media(for: library)
        }
    }
    
    func testFindMediaByArtistPerformance1() {
        guard let artist = MediaManager.artists.first else {
            XCTFail()
            return
        }
        measure {
            let _ = MediaManager.shared.media(by: artist)
        }
    }
    
    func testFindMediaByArtistPerformance2() {
        guard let artist = MediaManager.artists.last else {
            XCTFail()
            return
        }
        measure {
            let _ = MediaManager.shared.media(by: artist)
        }
    }
    
    func testFindMediaByIdentifierPerformance2() {
        guard let last = MediaManager.media.last else {
            XCTFail()
            return
        }
        measure {
            let _ = MediaManager.shared.media(with: last.identifier)
        }
    }
}
