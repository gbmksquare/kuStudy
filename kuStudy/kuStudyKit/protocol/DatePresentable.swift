//
//  DatePresentable.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 7..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public protocol DatePresentable {
    var updatedTime: NSDate { get }
}

public extension DatePresentable {
    public var updatedTimeString: String {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        return formatter.stringFromDate(updatedTime)
    }
}
