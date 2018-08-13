//
//  ArtistTests.swift
//  kuStudyTests
//
//  Created by BumMo Koo on 2018. 8. 13..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import Foundation
import XCTest
@testable import kuStudy

class ArtistTests: XCTestCase {
    // MARK: - Setup
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test
    func testArtistsDuplication() {
        let artists = MediaManager.artists
        let identifiers = artists.compactMap({ $0.identifier })
        let names = artists.compactMap({ $0.name })
        let identifierSet = Set(identifiers)
        let nameSet = Set(names)
        XCTAssert(identifierSet.count == artists.count)
        XCTAssert(nameSet.count == artists.count)
    }
    
    func testAritstsSocialAccount() {
        let artists = MediaManager.artists
        artists.forEach {
            for account in $0.socialAccounts {
                if let url = account.webUrl {
                    let description = UUID().uuidString
                    let expectation = XCTestExpectation(description: description)
                    let task = URLSession.shared.dataTask(with: url, completionHandler: { (_, response, _) in
                        if let code = (response as? HTTPURLResponse)?.statusCode {
                            XCTAssert(code == 200)
                        } else {
                            XCTFail()
                        }
                        expectation.fulfill()
                    })
                    task.resume()
                    wait(for: [expectation], timeout: 10)
                }
            }
        }
    }
}
