//
//  Summary.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 4..
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

public class SummaryViewModel {
    public let total: Int
    public let available: Int
    public var used: Int { return total - available }
    public var totalString: String { return "\(total)" }
    public var availableString: String { return "\(available)" }
    public var usedString: String { return "\(used)" }
    
    public var usedPercentage: Float { return Float(used) / Float(total) }
    public var usedPercentageString: String { return "\(Int(usedPercentage * 100))%" }
    public var usedPercentageColor: UIColor {
        switch usedPercentage {
        case let p where p > 0.9: return kuStudyColorError
        case let p where p > 0.8: return kuStudyColorWarning
        case let p where p > 0.7: return kuStudyColorLightWarning
        default: return kuStudyColorConfirm
        }
    }
    
    public init(summary: Summary) {
        total = summary.total
        available = summary.available
    }
}