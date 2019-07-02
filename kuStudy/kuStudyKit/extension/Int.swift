//
//  Int.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 21..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public extension Int {
    var readable: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let number = NSNumber(integerLiteral: self)
        let string = formatter.string(from: number)
        return string ?? ""
    }
}
