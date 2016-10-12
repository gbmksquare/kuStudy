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
    
    required public init?(map: Map) {
        
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

extension SectorData: PercentagePresentable {
    public var availableSeats: Int? {
        guard let totalSeats = totalSeats,
            let usedSeats = usedSeats,
            let ineligibleSeats = ineligibleSeats,
            let outOfOrderSeats = outOfOrderSeats,
            let disabledOnlySeats = disabledOnlySeats
            else { return nil }
        return totalSeats - usedSeats - ineligibleSeats - outOfOrderSeats - disabledOnlySeats
    }
    
    public var availablePercentage: Float {
        guard let availableSeats = availableSeats, let totalSeats = totalSeats else { return 0 }
        return Float(availableSeats) / Float(totalSeats)
    }
    
    public var usedPercentage: Float {
        guard let usedSeats = usedSeats, let totalSeats = totalSeats else { return 0 }
        return Float(usedSeats) / Float(totalSeats)
    }
}
