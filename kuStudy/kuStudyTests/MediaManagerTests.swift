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
            manager.clearCacheIfNecessary()
        }
    }
}
