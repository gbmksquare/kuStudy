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
    public var identifier: String?
    public var name: String?
    public var total: Int?
    public var occupied: Int?
    public var disabledOnly: Int?
    
    public var laptopCapable: Bool?
    public var openTime: Date?
    public var closeTime: Date?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        identifier <- map["code"]
        name <- map["name"]
        total <- map["available"]
        occupied <- map["inUse"]
        disabledOnly <- map["disabled"]
        laptopCapable <- (map["noteBookYN"], YesNoTransform())
        openTime <- (map["startTm"], OpenTimeTransform())
        closeTime <- (map["endTm"], CloseTimeTransform())
    }
}

extension SectorData: PercentagePresentable {
    public var available: Int? {
        guard let total = total, let occupied = occupied else  { return nil }
        return total - occupied
    }
    
    public var availablePercentage: Float {
        guard let available = available, let total = total else { return 0 }
        return Float(available) / Float(total)
    }
    
    public var occupiedPercentage: Float {
        guard let occupied = occupied, let total = total else { return 0 }
        return Float(occupied) / Float(total)
    }
}
