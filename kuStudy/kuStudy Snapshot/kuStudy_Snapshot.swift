//
//  kuStudy_Snapshot.swift
//  kuStudy Snapshot
//
//  Created by BumMo Koo on 2016. 8. 25..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import XCTest
import SimulatorStatusMagic

class kuStudy_Snapshot: XCTestCase {
    //  MARK: - Setup
    override class func setUp() {
        super.setUp()
        SDStatusBarManager.sharedInstance().enableOverrides()
    }
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        // Rotate device
        let device = XCUIDevice.shared
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
    
    override class func tearDown() {
        super.tearDown()
        SDStatusBarManager.sharedInstance().disableOverrides()
    }
    
    // MARK: - Snapshot
    func testSnapshot() {
        let app = XCUIApplication()
        let tables = app.tables
        let tabBars = app.tabBars
        let backButton = tabBars.buttons["Tab 0"]
        
        snapshot("0")
        
        let cellIds = (0...4).map { "Cell \($0)" }
        let names = ["1", "2", "3", "4", "5"]
        
        for (index, cellId) in cellIds.enumerated() {
            // iPad doesn't require this screenshot because it's the same as 0.png
            if index == 0, UIDevice.current.userInterfaceIdiom == .pad { continue }
                
            let cell = tables.cells[cellId]
            if cell.isHittable {
                cell.tap()
                snapshot(names[index])
                backButton.tap()
            } else {
                // Drag to cell
//                let topCoordinate = app.statusBars.firstMatch.coordinate(withNormalizedOffset: .zero)
//                let cellCoordinate = cell.coordinate(withNormalizedOffset: .zero)
//                cellCoordinate.press(forDuration: 0.05, thenDragTo: topCoordinate)
//                
//                cell.tap()
//                snapshot(names[index])
//                backButton.tap()
            }
        }
        
        // iPad doesn't require this screenshot because it's the same as 0_main
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            tables.cells["Cell 0"].tap()
//            snapshot("1_First")
//            tabBars.buttons["Tab 0"].tap()
//        }
//
//        tables.cells["Cell 1"].tap()
//        snapshot("2_Second")
//        backButton.tap()
//
//        tables.cells["Cell 2"].tap()
//        snapshot("3_Third")
//        backButton.tap()
//
//        tables.cells["Cell 3"].tap()
//        snapshot("4_Fourth")
//        tabBars.buttons["Tab 0"].tap()
//
//        tables.cells["Cell 4"].tap()
//        snapshot("5_Fifth")
//        tabBars.buttons["Tab 0"].tap()
        

//        // iPad doesn't require this screenshot because it's the same as 0_main
//        if UIDevice.current.userInterfaceIdiom != .pad {
//            tables.cells.element(boundBy: 1).tap()
//            snapshot("1_First")
//            tapBackButton()
//        }
//
//        tables.cells.element(boundBy: 2).tap()
//        snapshot("2_Second")
//        tapBackButton()
//
//        tables.cells.element(boundBy: 4).tap()
//        snapshot("3_Third")
    }
    
    // MARK: Helper
    private func tapBackButton() {
        if UIDevice.current.userInterfaceIdiom != .pad {
//            let button = XCUIApplication().navigationBars["kuStudy.LibraryView"].buttons[" "]
//            button.tap()
            
            // Swipe back gesture
            let app = XCUIApplication()
            let coord1 = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.15))
            let coord2 = coord1.withOffset(CGVector(dx: 300, dy: 0))
            coord1.press(forDuration: 0.05, thenDragTo: coord2)
        }
    }
}
