//
//  kuStudy_Snapshot.swift
//  kuStudy Snapshot
//
//  Created by BumMo Koo on 2016. 8. 25..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import XCTest

class kuStudy_Snapshot: XCTestCase {
    private let app = XCUIApplication()
    
    //  MARK: - Setup
    override class func setUp() {
        super.setUp()
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
        setupSnapshot(app)
        app.launchArguments = ["Snapshot"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Snapshot
    func testSnapshot() {
        let deviceInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        let collectionView = app.collectionViews.firstMatch
        let cells = collectionView.cells
        
        if deviceInterfaceIdiom == .phone {
            snapshot("0")
        }
        
        (1...3).forEach { index in
            let cell = cells.element(boundBy: index)
            cell.tap()
            snapshot("\(index)")
            
            if index == 3 {
                cells.firstMatch.tap()
                snapshot("\(index)_detail")
                return
            }
            
            if deviceInterfaceIdiom == .phone {
                let backButton = app.navigationBars.buttons.firstMatch
                backButton.tap()
            }
        }
    }
}
