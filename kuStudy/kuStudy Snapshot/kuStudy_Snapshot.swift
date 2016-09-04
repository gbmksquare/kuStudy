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
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSnapshot() {
        snapshot("0_Main")
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.cells.elementBoundByIndex(0).tap()
        snapshot("1_First")
        
        let button = app.navigationBars["kuStudy.LibraryView"].buttons[" "]
        button.tap()
        tablesQuery.cells.elementBoundByIndex(3).tap()
        snapshot("2_Second")
        button.tap()
    }
    
}
