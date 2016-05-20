//
//  Library.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 4..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation

@available(*, deprecated=1) public struct Library: Identifiable, Seatable, PercentageColorPresentable, ImagePresentable {
    public var id = 0
    public var key = ""
    public var total = 0
    public var available = 0
}

public extension Library {
    public func dictionaryValue() -> NSDictionary {
        return ["id": id, "key": key, "total": total, "available": available]
    }
    
    public init?(dictionary: NSDictionary) {
        guard let id = dictionary["id"]?.integerValue,
            key = dictionary.valueForKey("key") as? String,
            total = dictionary["total"]?.integerValue,
            available = dictionary["available"]?.integerValue else {
                return nil
        }
        
        self.id = id
        self.key = key
        self.total = total
        self.available = available
    }
}
