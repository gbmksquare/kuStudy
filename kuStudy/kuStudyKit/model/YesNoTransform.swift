//
//  YesNoTransform.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 6..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import ObjectMapper

class YesNoTransform: TransformType {
    public typealias Object = Bool
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Bool? {
        if let raw = value as? String {
            return raw == "Y" ? true : false
        }
        return nil
    }
    
    open func transformToJSON(_ value: Bool?) -> String? {
        if let value = value {
            return value == true ? "Y" : "N"
        }
        return nil
    }
}
