//
//  CloseTimeTransform.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 6..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import ObjectMapper

class CloseTimeTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        if let raw = value as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "hhmm a"
            
            let time = raw + " AM"
            return formatter.date(from: time)
        }
        return nil
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            let formatter = DateFormatter()
            formatter.dateFormat = "hhmm"
            return formatter.string(from: date)
        }
        return nil
    }
}
