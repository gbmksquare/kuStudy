//
//  SummaryData.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 22..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public class SummaryData {
    // TODO: Set to internal
    public var libraries = [LibraryData]()
    
    @available(*, deprecated: 1.0)
    public init() { }
    
    public init(libraryData: [LibraryData]) {
        libraries = libraryData
    }
}

// MARK: Computed data
extension SummaryData {
    public var total: Int? {
        return libraries.reduce(0, { (initial, library) -> Int in
            return initial + library.total
        })
    }
    
    public var occupied: Int? {
        return libraries.reduce(0, { (initial, library) -> Int in
            return initial + library.occupied
        })
    }
    
    public var available: Int? {
        return libraries.reduce(0, { (initial, library) -> Int in
            return initial + library.available
        })
    }
}

extension SummaryData {
    public var liberalArtCampusData: SummaryData {
        let ids = LibraryType.liberalArtCampusTypes().map({ $0.rawValue })
        let libraryDatas = libraries.filter { (libraryData) -> Bool in
            guard let libraryId = libraryData.libraryId else { return false }
            if ids.contains(libraryId) {
                return true
            } else {
                return false
            }
        }
        return SummaryData(libraryData: libraryDatas)
    }
    
    public var scienceCampusData: SummaryData {
        let ids = LibraryType.scienceCampusTypes().map({ $0.rawValue })
        let libraryDatas = libraries.filter { (libraryData) -> Bool in
            guard let libraryId = libraryData.libraryId else { return false }
            if ids.contains(libraryId) {
                return true
            } else {
                return false
            }
        }
        return SummaryData(libraryData: libraryDatas)
    }
}

extension SummaryData: PercentagePresentable {
    public var availablePercentage: Float {
        guard total != 0 else { return 0 }
        guard let available = available, let total = total else { return 0 }
        return Float(available) / Float(total)
    }
    
    public var occupiedPercentage: Float {
        guard total != 0 else { return 0 }
        guard let occupied = occupied, let total = total else { return 0 }
        return Float(occupied) / Float(total)
    }
}
