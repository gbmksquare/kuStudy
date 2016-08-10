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
    public var libraryId: String?
    public var sectorCount: Int?
    public var sectors: [SectorData]?
    
    required public  init?(_ map: Map) { }
    
    public func mapping(map: Map) {
        libraryId <- map["pLibNo"]
        sectorCount <- map["statListCnt"]
        sectors <- map["statList"]
    }
}

// MARK: Computed data
public extension LibraryData {
    public var totalSeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, combine: { (initial, sector) -> Int in
            return initial + (sector.totalSeats ?? 0)
        })
    }
    
    public var usedSeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, combine: { (initial, sector) -> Int in
            return initial + (sector.usedSeats ?? 0)
        })
    }
    
    public var availableSeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, combine: { (initial, sector) -> Int in
            return initial + (sector.availableSeats ?? 0)
        })
    }
    
    public var ineligibleSeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, combine: { (initial, sector) -> Int in
            return initial + (sector.ineligibleSeats ?? 0)
        })
    }
    
    public var outOfOrderSeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, combine: { (initial, sector) -> Int in
            return initial + (sector.outOfOrderSeats ?? 0)
        })
    }
    
    public var disabledOnlySeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, combine: { (initial, sector) -> Int in
            return initial + (sector.disabledOnlySeats ?? 0)
        })
    }
    
    public var printerCount: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, combine: { (initial, sector) -> Int in
            return initial + (sector.printerCount ?? 0)
        })
    }
    
    public var scannerCount: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, combine: { (initial, sector) -> Int in
            return initial + (sector.scannerCount ?? 0)
        })
    }
}

extension LibraryData: PercentagePresentable {
    public var availablePercentage: Float {
        guard totalSeats != 0 else { return 0 }
        return Float(availableSeats) / Float(totalSeats)
    }
    
    public var usedPercentage: Float {
        guard totalSeats != 0 else { return 0 }
        return Float(usedSeats) / Float(totalSeats)
    }
}

// MARK:
// MARK: Image
public extension LibraryData {
    public var thumbnail: UIImage? {
        get {
            guard let libraryIdString = self.libraryId else { return nil }
            guard let libraryId = Int(libraryIdString) else { return nil }
            return ImageProvider.sharedProvider.thumbnailForLibrary(libraryId)
        }
    }
    
    public var photo: (image: UIImage, photographer: Photographer)? {
        get {
            guard let libraryIdString = self.libraryId else { return nil }
            guard let libraryId = Int(libraryIdString) else { return nil }
            return ImageProvider.sharedProvider.photoForLibrary(libraryId)
        }
    }
}
