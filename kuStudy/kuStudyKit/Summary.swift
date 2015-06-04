//
//  Summary.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 4..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import RealmSwift

public class Summary {
    public var total: Int
    public var available: Int
    
    public init(total: Int, available: Int) {
        self.total = total
        self.available = available
    }
}
