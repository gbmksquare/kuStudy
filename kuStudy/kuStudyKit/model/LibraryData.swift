//
//  LibraryData.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 20..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation
import ObjectMapper

public class LibraryData: Mappable {
    internal var libraryId: String?
    public var sectors: [SectorData]?
    
    required public init?(map: Map) { }
    
    public convenience init?(libraryId: String, JSONString: String) {
        self.init(JSONString: JSONString)
        self.libraryId = libraryId
    }
    
    public func mapping(map: Map) {
        sectors <- map["data"]
    }
}

// MARK: Computed data
public extension LibraryData {
    var libraryType: LibraryType? {
        guard let libraryId = libraryId else { return nil }
        return LibraryType(rawValue: libraryId)
    }
    
    var libraryName: String {
        return libraryType?.name ?? ""
    }
    
    var total: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (sector.total ?? 0)
        })
    }
    
    var occupied: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (sector.occupied ?? 0)
        })
    }
    
    var available: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (sector.available ?? 0)
        })
    }
}

extension LibraryData: PercentagePresentable {
    public var availablePercentage: Float {
        guard total != 0 else { return 0 }
        return Float(available) / Float(total)
    }
    
    public var occupiedPercentage: Float {
        guard total != 0 else { return 0 }
        return Float(occupied) / Float(total)
    }
}
