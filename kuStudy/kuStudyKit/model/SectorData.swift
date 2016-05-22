//
//  Sector.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 20..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation
import ObjectMapper

public class SectorData: Mappable {
    public var libraryName: String?
    public var roomName: String?
    public var sectorName: String?
    public var roomId: Int?
    public var sectorId: Int?
    public var floor: Int?
    public var totalSeats: Int?
    public var usedSeats: Int?
    public var ineligibleSeats: Int?
    public var outOfOrderSeats: Int?
    public var disabledOnlySeats: Int?
    public var printerCount: Int?
    public var scannerCount: Int?
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        libraryName <- map["libName"]
        roomName <- map["roomName"]
        sectorName <- map["sectorName"]
        roomId <- map["roomNo"]
        sectorId <- map["sectorNo"]
        floor <- map["floor"]
        totalSeats <- map["seatCnt"]
        usedSeats <- map["inUseCnt"]
        ineligibleSeats <- map["ineligibleCnt"]
        outOfOrderSeats <- map["outOfOrderCnt"]
        disabledOnlySeats <- map["disabledOnlyCnt"]
        printerCount <- map["printerCnt"]
        scannerCount <- map["scannerCnt"]
    }
}

// MARK:
// MARK: Computed data
public extension SectorData {
    public var availableSeats: Int? {
        guard let totalSeats = totalSeats,
            usedSeats = usedSeats,
            ineligibleSeats = ineligibleSeats,
            outOfOrderSeats = outOfOrderSeats,
            disabledOnlySeats = disabledOnlySeats
            else { return nil }
        return totalSeats - usedSeats - ineligibleSeats - outOfOrderSeats - disabledOnlySeats
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
