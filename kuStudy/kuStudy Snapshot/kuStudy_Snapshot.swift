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
        let tabBar = app.tabBars.firstMatch
        let backButton = tabBar.buttons["Tab 0"]
        let deviceInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        
        snapshot("0")
        
        let cellIds = (0...4).map { "Summary Cell \($0)" }
        let names = ["1", "2", "3", "4", "5"]
        
        for (index, cellId) in cellIds.enumerated() {
            // iPad doesn't require this screenshot because it's the same as 0.png
            if index == 0, deviceInterfaceIdiom == .pad { continue }
                
            let cell = tables.cells[cellId]
            if cell.isHittable {
                cell.tap()
                snapshot(names[index])
                if deviceInterfaceIdiom == .phone {
                 backButton.tap()
                }
            } else {
                // Drag to cell
                tables.firstMatch.scrollTo(element: cell)

                cell.tap()
                snapshot(names[index])
                if deviceInterfaceIdiom == .phone {
                    backButton.tap()
                }
            }
        }
    }
}
