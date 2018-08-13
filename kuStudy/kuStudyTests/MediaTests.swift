//
//  MediaTests.swift
//  kuStudyTests
//
//  Created by BumMo Koo on 2018. 8. 13..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import Foundation
import XCTest
@testable import kuStudy

class MediaTests: XCTestCase {
    // MARK: - Setup
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test
    func testMediaDuplication() {
        let media = MediaManager.media
        let identifiers = media.compactMap({ $0.identifier })
        let resourceNames = media.compactMap({ $0.resourceName })
        let identifierSet = Set(identifiers)
        let resourceNameSet = Set(resourceNames)
        XCTAssert(identifierSet.count == media.count)
        XCTAssert(resourceNameSet.count == media.count)
    }
    
    func testUnknownArtsit() {
        let media = MediaManager.media
        let artists = media.compactMap({ $0.artistIdentifier })
        let verifiedArtists = MediaManager.artists.compactMap({ $0.identifier })
        for artist in artists {
            XCTAssert(verifiedArtists.contains(artist) == true)
        }
    }
    
    func testValidImage() {
        let media = MediaManager.media
//        let resourceNames = media.compactMap({ $0.resourceName })
        for item in media {
            XCTAssertNotNil(item.image)
            XCTAssertNotNil(item.thumbnail)
        }
    }
}
