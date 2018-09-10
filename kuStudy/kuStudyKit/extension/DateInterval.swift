//
//  DateInterval.swift
//  kuStudy
//
//  Created by BumMo Koo on 10/09/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import Foundation

public extension DateInterval {
    public var isActive: Bool {
        let today = Date()
        return contains(today)
    }
    
    public var lasts: Int {
        return Int(duration / 60 / 60 / 24)
    }
}
