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
    
    required public  init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        libraryId <- map["pLibNo"]
        sectorCount <- map["statListCnt"]
        sectors <- map["statList"]
    }
}

// MARK: Computed data
public extension LibraryData {
    public var totalSeats: Int? {
        guard let sectors = self.sectors else { return nil }
        var totalSeats = 0
        for sector in sectors {
            if let seats = sector.totalSeats {
                totalSeats += seats
            }
        }
        return totalSeats
    }
    
    public var usedSeats: Int? {
        guard let sectors = self.sectors else { return nil }
        var usedSeats = 0
        for sector in sectors {
            if let seats = sector.usedSeats {
                usedSeats += seats
            }
        }
        return usedSeats
    }
    
    public var availableSeats: Int? {
        guard let sectors = self.sectors else { return nil }
        var availableSeats = 0
        for sector in sectors {
            if let seats = sector.availableSeats {
                availableSeats += seats
            }
        }
        return availableSeats
    }
    
    public var ineligibleSeats: Int? {
        guard let sectors = self.sectors else { return nil }
        var ineligibleSeats = 0
        for sector in sectors {
            if let seats = sector.ineligibleSeats {
                ineligibleSeats += seats
            }
        }
        return ineligibleSeats    }
    
    public var outOfOrderSeats: Int? {
        guard let sectors = self.sectors else { return nil }
        var outOfOrderSeats = 0
        for sector in sectors {
            if let seats = sector.outOfOrderSeats {
                outOfOrderSeats += seats
            }
        }
        return outOfOrderSeats
    }
    
    public var disabledOnlySeats: Int? {
        guard let sectors = self.sectors else { return nil }
        var disabledOnlySeats = 0
        for sector in sectors {
            if let seats = sector.disabledOnlySeats {
                disabledOnlySeats += seats
            }
        }
        return disabledOnlySeats
    }
    
    public var printerCount: Int? {
        guard let sectors = self.sectors else { return nil }
        var printerCount = 0
        for sector in sectors {
            if let seats = sector.printerCount {
                printerCount += seats
            }
        }
        return printerCount
    }
    
    public var scannerCount: Int? {
        guard let sectors = self.sectors else { return nil }
        var scannerCount = 0
        for sector in sectors {
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
