//
//  Date.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 25..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation

public extension Date {
    public var readable: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
