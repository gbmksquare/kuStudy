//
//  SectorDataTests.swift
//  kuStudyKitTests
//
//  Created by BumMo Koo on 07/08/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import Foundation
import XCTest
@testable import kuStudyKit

class SectorDataTests: XCTestCase {
    private lazy var sampleSectorData = SectorData(JSONString: sampleSectorJsonString)
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test
    func testSectorDataInit() {
        XCTAssertNotNil(sampleSectorData)
    }
    
    func testSectorDataValues() {
        guard let data = sampleSectorData else {
            XCTFail()
            return
        }
        XCTAssertNotNil(data.identifier)
        XCTAssertNotNil(data.name)
        XCTAssertNotNil(data.total)
        XCTAssertNotNil(data.occupied)
        XCTAssertNotNil(data.disabledOnly)
        XCTAssertNotNil(data.fixing)
        XCTAssertNotNil(data.unavailable)
        XCTAssertNotNil(data.laptopCapable)
        XCTAssertNotNil(data.openTime)
        XCTAssertNotNil(data.closeTime)
        XCTAssertNotNil(data.available)
        XCTAssertNotNil(data.availablePercentage)
        XCTAssertNotNil(data.occupiedPercentage)
        XCTAssertNotNil(data.occupiedPercentageColor)
    }
}

private let sampleSectorJsonString = """
{
"code": 6,
"name": "유선노트북열람실",
"nameEng": "Reading Room 1(Laptop)",
"scCkMi": "10",
"bgImg": "/resources/image/layout/centralPlaza/csquare01.jpg",
"previewImg": "/resources/image/appBg/centralPlaza/유선노트북열람실.jpg",
"miniMapImg": "/resources/image/minimap/centralPlaza/wiredNotebook.png",
"noteBookYN": "Y",
"maxMi": 240,
"maxRenewMi": 240,
"startTm": "0000",
"endTm": "0000",
"wkStartTm": "0000",
"wkEndTm": "0000",
"wkSetting": "NNNNNNN",
"wkTimeUseSetting": "YNNNNNY",
"wkRsrvUseYn": "Y",
"cnt": 258,
"available": 258,
"inUse": 58,
"fix": 0,
"disabled": 0,
"fixedSeat": 0,
"normal": 0,
"unavailable": 0
}
"""
