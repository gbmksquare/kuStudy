//
//  Library.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation

public class Summary {
    public var total: Int
    public var available: Int
    
    public init(total: Int, available: Int) {
        self.total = total
        self.available = available
    }
}

public class Library {
    public var id: Int
    public var total: Int
    public var available: Int
    
    public init(id: Int, total: Int, available: Int) {
        self.id = id
        self.total = total
        self.available = available
    }
}

public class ReadingRoom {
    public var id: Int
    public var total: Int
    public var available: Int
    
    public init(id: Int, total: Int, available: Int) {
        self.id = id
        self.total = total
        self.available = available
    }
}
