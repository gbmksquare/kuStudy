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
    
    required public  init?(map: Map) { }
    
    public func mapping(map: Map) {
        sectors <- map["data"]
    }
}

// MARK: Computed data
public extension LibraryData {
    public var libraryType: LibraryType? {
        guard let libraryId = libraryId else { return nil }
        return LibraryType(rawValue: libraryId)
    }
    
    public var libraryName: String {
        return libraryType?.name ?? ""
    }
    
    public var total: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (sector.total ?? 0)
        })
    }
    
    public var occupied: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (sector.occupied ?? 0)
        })
    }
    
    public var available: Int {
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

// MARK: - Image
public extension LibraryData {
    public var media: Media? {
        guard let libraryId = self.libraryId else { return nil }
        guard let libraryType = LibraryType(rawValue: libraryId) else { return nil }
        return MediaManager.shared.media(for: libraryType)
    }
}
