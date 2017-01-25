//
//  kuStudy_Snapshot.swift
//  kuStudy Snapshot
//
//  Created by BumMo Koo on 2016. 8. 25..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import XCTest

class kuStudy_Snapshot: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        // Rotate device
        let device = XCUIDevice.shared()
        if UIDevice.current.userInterfaceIdiom == .pad {
            device.orientation = .landscapeRight
        } else {
            device.orientation = .portrait
        }
        
        // Launch
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSnapshot() {
        snapshot("0_Main")
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.cells.element(boundBy: 0).tap()
        snapshot("1_First")
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            let button = app.navigationBars["kuStudy.LibraryView"].buttons[" "]
            button.tap()
        }
        
        tablesQuery.cells.element(boundBy: 3).tap()
        snapshot("2_Second")
    }
    
}
