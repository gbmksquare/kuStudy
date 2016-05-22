//
//  Float.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 22..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public extension Float {
    public var readablePercentageFormat: String {
        let numberFormmater = NSNumberFormatter()
        numberFormmater.numberStyle = .PercentStyle
        let string = numberFormmater.stringFromNumber(self)
        return string ?? ""
    }
}
