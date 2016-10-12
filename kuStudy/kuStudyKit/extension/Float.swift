//
//  Float.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 22..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public extension Float {
    public var percentageReadable: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        let number = NSNumber(floatLiteral: Double(self))
        let string = formatter.string(from: number)
        return string ?? ""
    }
}
