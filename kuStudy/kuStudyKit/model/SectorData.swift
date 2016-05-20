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
