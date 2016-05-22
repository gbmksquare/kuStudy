//
//  Int.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 21..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public extension Int {
    public var readableFormat: String {
        let numberFormmater = NSNumberFormatter()
        numberFormmater.numberStyle = .DecimalStyle
        let string = numberFormmater.stringFromNumber(self)
        return string ?? ""
    }
}
