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
    
    public init() {
        
    }
}

// MARK: Computed data
extension SummaryData {
    public var totalSeats: Int? {
        var totalSeats = 0
        for sector in libraries {
            if let seats = sector.totalSeats {
                totalSeats += seats
            }
        }
        return totalSeats
    }
    
    public var usedSeats: Int? {
        var usedSeats = 0
        for sector in libraries {
            if let seats = sector.usedSeats {
                usedSeats += seats
            }
        }
        return usedSeats
    }
    
    public var availableSeats: Int? {
        var availableSeats = 0
        for sector in libraries {
            if let seats = sector.availableSeats {
                availableSeats += seats
            }
        }
        return availableSeats
    }
    
    public var ineligibleSeats: Int? {
        var ineligibleSeats = 0
        for sector in libraries {
            if let seats = sector.ineligibleSeats {
                ineligibleSeats += seats
            }
        }
        return ineligibleSeats    }
    
    public var outOfOrderSeats: Int? {
        var outOfOrderSeats = 0
        for sector in libraries {
            if let seats = sector.outOfOrderSeats {
                outOfOrderSeats += seats
            }
        }
        return outOfOrderSeats
    }
    
    public var disabledOnlySeats: Int? {
        var disabledOnlySeats = 0
        for sector in libraries {
            if let seats = sector.disabledOnlySeats {
                disabledOnlySeats += seats
            }
        }
        return disabledOnlySeats
    }
    
    public var printerCount: Int? {
        var printerCount = 0
        for sector in libraries {
            if let seats = sector.printerCount {
                printerCount += seats
            }
        }
        return printerCount
    }
    
    public var scannerCount: Int? {
        var scannerCount = 0
        for sector in libraries {
            if let seats = sector.scannerCount {
                scannerCount += seats
            }
        }
        return scannerCount
    }
    
    public var usedPercentage: Float {
        guard let usedSeats = usedSeats, totalSeats = totalSeats else { return 0 }
        return Float(usedSeats) / Float(totalSeats)
    }
    
    public var usedPercentageColor: UIColor {
        switch usedPercentage {
        case let p where p > 0.9: return kuStudyColorError
        case let p where p > 0.75: return kuStudyColorWarning
        case let p where p > 0.6: return kuStudyColorLightWarning
        default: return kuStudyColorConfirm
        }
    }
}
