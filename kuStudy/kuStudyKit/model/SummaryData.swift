//
//  SummaryData.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 22..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public class SummaryData {
    public var libraries = [LibraryData]()
    
    public init() { }
}

// MARK: Computed data
extension SummaryData {
    public var totalSeats: Int? {
        return libraries.reduce(0, combine: { (initial, library) -> Int in
            return initial + library.totalSeats
        })
    }
    
    public var usedSeats: Int? {
        return libraries.reduce(0, combine: { (initial, library) -> Int in
            return initial + library.usedSeats
        })
    }
    
    public var availableSeats: Int? {
        return libraries.reduce(0, combine: { (initial, library) -> Int in
            return initial + library.availableSeats
        })
    }
    
    public var ineligibleSeats: Int? {
        return libraries.reduce(0, combine: { (initial, library) -> Int in
            return initial + library.ineligibleSeats
        })
    }
    
    public var outOfOrderSeats: Int? {
        return libraries.reduce(0, combine: { (initial, library) -> Int in
            return initial + library.outOfOrderSeats
        })
    }
    
    public var disabledOnlySeats: Int? {
        return libraries.reduce(0, combine: { (initial, library) -> Int in
            return initial + library.disabledOnlySeats
        })
    }
    
    public var printerCount: Int? {
        return libraries.reduce(0, combine: { (initial, library) -> Int in
            return initial + library.printerCount
        })
    }
    
    public var scannerCount: Int? {
        return libraries.reduce(0, combine: { (initial, library) -> Int in
            return initial + library.scannerCount
        })
    }
}

extension SummaryData: PercentagePresentable {
    public var availablePercentage: Float {
        guard let availableSeats = availableSeats, totalSeats = totalSeats else { return 0 }
        return Float(availableSeats) / Float(totalSeats)
    }
    
    public var usedPercentage: Float {
        guard let usedSeats = usedSeats, totalSeats = totalSeats else { return 0 }
        return Float(usedSeats) / Float(totalSeats)
    }
}
