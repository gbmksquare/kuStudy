//
//  LibraryTypeTest.swift
//  kuStudyKitTests
//
//  Created by BumMo Koo on 07/08/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import Foundation
import XCTest
@testable import kuStudyKit

class LibraryTypeTests: XCTestCase {
    // MARK: - Setup
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test
    func testLibraryType() {
        let all = LibraryType.allTypes()
        let set = NSSet(array: all)
        XCTAssert(all.count == set.count, "Duplicate library IDs.")
    }
    
    func testCampusDivision() {
        let liberalArt = LibraryType.liberalArtCampusTypes()
        let science = LibraryType.scienceCampusTypes()
        let all = LibraryType.allTypes()
        XCTAssert(all.count == liberalArt.count + science.count, "Missing library in campus.")
    }
    
    func testNames() {
        let all = LibraryType.allTypes()
        for library in all {
            XCTAssertNotNil(library.name)
            XCTAssert(library.name != "", "Library name can't be empty.")
            XCTAssertNotNil(library.nameInAlternateLanguage)
            XCTAssert(library.nameInAlternateLanguage != "", "Library name can't be empty.")
            XCTAssert(library.name != library.nameInAlternateLanguage, "Library name shouldn't be same in different languages.")
            XCTAssert(library.shortName != "", "Library name can't be empty.")
            XCTAssert(library.shortName.count <= 2, "Librarry short name can't be too long.")
        }
    }
    
    func testCoordinates() {
        let all = LibraryType.allTypes()
        for library in all {
            XCTAssertNotNil(library.coordinate)
        }
    }
    
    func testWebUrl() {
        let all = LibraryType.allTypes()
        for library in all {
            let url = library.url
            XCTAssertNotNil(url)
        }
    }
    
    func testWebUrlResponse() {
        let all = LibraryType.allTypes()
        for (index, library) in all.enumerated() {
            guard let url = library.url else { continue }
            let expectation = XCTestExpectation(description: "Library Web URL Response \(index)")
            let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                XCTAssertNotNil(data)
                expectation.fulfill()
            }
            task.resume()
            wait(for: [expectation], timeout: 10)
        }
    }
    
    func testApiUrl() {
        let all = LibraryType.allTypes()
        for library in all {
            XCTAssert(library.apiUrl != "", "Library API URL can't be empty.")
            XCTAssertNotNil(URL(string: library.apiUrl))
        }
    }
    
    func testApiUrlResponse() {
        let all = LibraryType.allTypes()
        for (index, library) in all.enumerated() {
            guard let url = URL(string: library.apiUrl) else { continue }
            let expectation = XCTestExpectation(description: "Library API URL Response \(index)")
            let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                XCTAssertNotNil(data)
                expectation.fulfill()
            }
            task.resume()
            wait(for: [expectation], timeout: 10)
        }
    }
}
