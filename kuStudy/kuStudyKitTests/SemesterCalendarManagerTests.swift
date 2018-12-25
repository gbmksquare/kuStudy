//
//  SemesterCalendarManagerTests.swift
//  kuStudyTests
//
//  Created by BumMo Koo on 25/12/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import XCTest
import kuStudyKit

class SemesterCalendarManagerTests: XCTestCase {
    private let manager = SemesterCalendarManager.shared

    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    // MARK: - Tests
    func testCurrentSemester() {
        if let activeSemester = manager.activeSemester {
            XCTAssertTrue(activeSemester.semester.isActive)
        }
    }
    
    func testDateInterval() {
        var start = Date(dateString: "2018-12-25 +0900")!
        var end = Date(dateString: "2018-12-26 +0900")!
        var interval = DateInterval(start: start, end: end)
        XCTAssertEqual(interval.lasts, 1)
        
        start = Date(dateString: "2018-01-01 +0900")!
        end = Date(dateString: "2019-01-01 +0900")!
        interval = DateInterval(start: start, end: end)
        XCTAssertEqual(interval.lasts, 365)
    }
}
