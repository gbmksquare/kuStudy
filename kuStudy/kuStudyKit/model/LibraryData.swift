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
    public var sectorCount: Int? {
        return sectors?.count
    }
    public var sectors: [SectorData]?
    
    required public  init?(map: Map) { }
    
    public func mapping(map: Map) {
//        libraryId <- map["pLibNo"]
//        sectorCount <- map["statListCnt"]
        sectors <- map["data"]
    }
}

// MARK: Computed data
public extension LibraryData {
    public var libraryName: String {
        guard let libraryId = libraryId else { return "" }
        let libraryType = LibraryType(rawValue: libraryId)
        return libraryType?.name ?? ""
    }
    
    public var totalSeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (sector.total ?? 0)
        })
    }
    
    public var usedSeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (sector.occupied ?? 0)
        })
    }
    
    public var availableSeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (sector.available ?? 0)
        })
    }
    
    public var ineligibleSeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (0)
        })
    }
    
    public var outOfOrderSeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (0)
        })
    }
    
    public var disabledOnlySeats: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (0)
        })
    }
    
    public var printerCount: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (0)
        })
    }
    
    public var scannerCount: Int {
        guard let sectors = sectors else { return 0 }
        return sectors.reduce(0, { (initial, sector) -> Int in
            return initial + (0)
        })
    }
}

extension LibraryData: PercentagePresentable {
    public var availablePercentage: Float {
        guard totalSeats != 0 else { return 0 }
        return Float(availableSeats) / Float(totalSeats)
    }
    
    public var occupiedPercentage: Float {
        guard totalSeats != 0 else { return 0 }
        return Float(usedSeats) / Float(totalSeats)
    }
}

// MARK: - Image
public extension LibraryData {
    public var thumbnail: UIImage? {
        get {
            guard let libraryIdString = self.libraryId else { return nil }
            guard let libraryId = Int(libraryIdString) else { return nil }
            return PhotoProvider.sharedProvider.photo(libraryId).thumbnail
        }
    }
    
    public var photo: (image: UIImage?, photographer: Photographer_Legacy)? {
        get {
            guard let libraryIdString = self.libraryId else { return nil }
            guard let libraryId = Int(libraryIdString) else { return nil }
            let photo = PhotoProvider.sharedProvider.photo(libraryId)
            return (photo.image, photo.photographer)
        }
    }
}
