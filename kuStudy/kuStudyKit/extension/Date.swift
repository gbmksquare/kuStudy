//
//  Date.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 25..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation

public extension Date {
    var readable: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    init?(dateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd Z"
        if let d = formatter.date(from: dateString) {
            self.init(timeInterval: 0, since: d)
        } else {
            return nil
        }
    }
    
    var daysFromToday: Int {
        let today = Date()
        return Calendar.current.dateComponents([.day], from: today, to: self).day!
    }
}
