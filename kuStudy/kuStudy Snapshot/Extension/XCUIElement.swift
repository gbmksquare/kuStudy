//
//  XCUIElement.swift
//  kuStudy Snapshot
//
//  Created by BumMo Koo on 2018. 8. 8..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElement {
    var isVisible: Bool {
        guard exists == true && isHittable == true && frame.isEmpty == false else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }
    
    func scrollTo(element: XCUIElement) {
        while element.isVisible == false {
            let app = XCUIApplication()
            let start = app.tables.element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            let end = start.withOffset(CGVector(dx: 0, dy: -262))
            start.press(forDuration: 0.01, thenDragTo: end)
        }
    }
}
