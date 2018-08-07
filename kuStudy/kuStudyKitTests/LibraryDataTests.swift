//
//  LibraryDataTests.swift
//  kuStudyKitTests
//
//  Created by BumMo Koo on 07/08/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import Foundation
import XCTest
@testable import kuStudyKit

class LibraryDataTests: XCTestCase {
    private lazy var sampleLibraryData = LibraryData(libraryId: LibraryType.centralSquare.rawValue,JSONString: sampleLibraryJsonString)
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test
    func testLibraryDataInit() {
        XCTAssertNotNil(sampleLibraryData)
    }
    
    func testLibraryDataValues() {
        guard let data = sampleLibraryData else {
            XCTFail()
            return
        }
        XCTAssertNotNil(data.libraryId)
        XCTAssertNotNil(data.sectors)
        if let sectors = data.sectors {
            XCTAssert(sectors.count > 0, "Data should have multiple sector data.")
        }
        XCTAssertNotNil(data.libraryType)
        XCTAssertNotNil(data.libraryName)
        XCTAssertNotNil(data.total)
        XCTAssertNotNil(data.occupied)
        XCTAssertNotNil(data.available)
        XCTAssertNotNil(data.occupiedPercentage)
        XCTAssertNotNil(data.availablePercentage)
        XCTAssertNotNil(data.media)
    }
    
    func testLibraryDataIdentifier() {
        guard let data = sampleLibraryData, let libraryId = data.libraryId else {
            XCTFail()
            return
        }
        let all = LibraryType.allTypes().map({ $0.identifier })
        XCTAssert(all.contains(libraryId) == true, "Unrecognized library ID.")
    }
}

private let sampleLibraryJsonString = """
{
"code": 1,
"status": 200,
"message": "SUCCESS",
"data": [
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
},
{
"code": 7,
"name": "열람전용실",
"nameEng": "Reading Room 2",
"scCkMi": "10",
"bgImg": "/resources/image/layout/centralPlaza/csquare02.jpg",
"previewImg": "/resources/image/appBg/centralPlaza/열람전용실.jpg",
"miniMapImg": "/resources/image/minimap/centralPlaza/openSpace.png",
"noteBookYN": "N",
"maxMi": 240,
"maxRenewMi": 240,
"startTm": "0000",
"endTm": "0000",
"wkStartTm": "0000",
"wkEndTm": "0000",
"wkSetting": "NNNNNNN",
"wkTimeUseSetting": "YNNNNNY",
"wkRsrvUseYn": "Y",
"cnt": 326,
"available": 325,
"inUse": 34,
"fix": 1,
"disabled": 0,
"fixedSeat": 0,
"normal": 0,
"unavailable": 0
},
{
"code": 10,
"name": "대학원열람실",
"nameEng": "Reading Room 3(Grad)",
"scCkMi": "10",
"bgImg": "/resources/image/layout/centralPlaza/csquare05.jpg",
"previewImg": "/resources/image/appBg/centralPlaza/대학원열람실.jpg",
"miniMapImg": "/resources/image/minimap/centralPlaza/graduate.png",
"noteBookYN": "N",
"maxMi": 240,
"maxRenewMi": 240,
"startTm": "0000",
"endTm": "0000",
"wkStartTm": "0000",
"wkEndTm": "0000",
"wkSetting": "NNNNNNN",
"wkTimeUseSetting": "YNNNNNY",
"wkRsrvUseYn": "Y",
"cnt": 120,
"available": 120,
"inUse": 22,
"fix": 0,
"disabled": 0,
"fixedSeat": 0,
"normal": 0,
"unavailable": 0
}
],
"success": true
}
"""
