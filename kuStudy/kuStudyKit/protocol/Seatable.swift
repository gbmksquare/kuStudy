//
//  Seatable.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 7..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public protocol Seatable {
    var total: Int { get }
    var available: Int { get }
}

public extension Seatable {
    public var used: Int { return total - available }
    public var usedPercentage: Float {
        return Float(used) / Float(total)
    }
}

public extension Seatable {
    private var formatter: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        return formatter
    }
    
    public var totalString: String {
        return formatter.stringFromNumber(total) ?? "-"
    }
    
    public var availableString: String {
        return formatter.stringFromNumber(available) ?? "-"
    }
    
    public var usedString: String {
        return formatter.stringFromNumber(used) ?? "-"
    }
    
    public var usedPercentageString: String? {
        return String(Int(usedPercentage)) + "%"
    }
}
