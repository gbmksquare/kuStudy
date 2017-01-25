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
        app.launchArguments = ["Snapshot"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test
    func testSnapshot() {
        snapshot("0_Main")
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.cells.element(boundBy: 1).tap()
        snapshot("1_First")
        
        tapBackButton()
        
        tablesQuery.cells.element(boundBy: 2).tap()
        snapshot("2_Second")
        
        tapBackButton()
        
        tablesQuery.cells.element(boundBy: 4).tap()
        snapshot("3_Third")
    }
    
    // MARK: Helper
    private func tapBackButton() {
        if UIDevice.current.userInterfaceIdiom != .pad {
            let button = XCUIApplication().navigationBars["kuStudy.LibraryView"].buttons[" "]
            button.tap()
        }
    }
}
