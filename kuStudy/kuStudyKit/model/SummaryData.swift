//
//  SummaryData.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 22..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public class SummaryData {
    public var libraries = [LibraryData]()
    
    public init() { }
}

// MARK: Computed data
extension SummaryData {
    public var totalSeats: Int? {
        return libraries.reduce(0, { (initial, library) -> Int in
            return initial + library.totalSeats
        })
    }
    
    public var usedSeats: Int? {
        return libraries.reduce(0, { (initial, library) -> Int in
            return initial + library.usedSeats
        })
    }
    
    public var availableSeats: Int? {
        return libraries.reduce(0, { (initial, library) -> Int in
            return initial + library.availableSeats
        })
    }
}

extension SummaryData {
    public var totalSeatsInLiberalArtCampus: Int? {
        let ids = LibraryType.liberalArtCampusTypes().map({ $0.rawValue })
        let libraryDatas = libraries.filter { (libraryData) -> Bool in
            guard let libraryId = libraryData.libraryId else { return false }
            if ids.contains(libraryId) {
                return true
            } else {
                return false
            }
        }
        return libraryDatas.reduce(0, { (initial, library) -> Int in
            return initial + library.totalSeats
        })
    }
    
    public var usedSeatsInLiberalArtCampus: Int? {
        let ids = LibraryType.liberalArtCampusTypes().map({ $0.rawValue })
        let libraryDatas = libraries.filter { (libraryData) -> Bool in
            guard let libraryId = libraryData.libraryId else { return false }
            if ids.contains(libraryId) {
                return true
            } else {
                return false
            }
        }
        return libraryDatas.reduce(0, { (initial, library) -> Int in
            return initial + library.usedSeats
        })
    }
    
    public var availableSeatsInLiberalArtCampus: Int? {
        let ids = LibraryType.liberalArtCampusTypes().map({ $0.rawValue })
        let libraryDatas = libraries.filter { (libraryData) -> Bool in
            guard let libraryId = libraryData.libraryId else { return false }
            if ids.contains(libraryId) {
                return true
            } else {
                return false
            }
        }
        return libraryDatas.reduce(0, { (initial, library) -> Int in
            return initial + library.availableSeats
        })
    }
    
    public var totalSeatsInScienceCampus: Int? {
        let ids = LibraryType.scienceCampusTypes().map({ $0.rawValue })
        let libraryDatas = libraries.filter { (libraryData) -> Bool in
            guard let libraryId = libraryData.libraryId else { return false }
            if ids.contains(libraryId) {
                return true
            } else {
                return false
            }
        }
        return libraryDatas.reduce(0, { (initial, library) -> Int in
            return initial + library.totalSeats
        })
    }
    
    public var usedSeatsInScienceCampus: Int? {
        let ids = LibraryType.scienceCampusTypes().map({ $0.rawValue })
        let libraryDatas = libraries.filter { (libraryData) -> Bool in
            guard let libraryId = libraryData.libraryId else { return false }
            if ids.contains(libraryId) {
                return true
            } else {
                return false
            }
        }
        return libraryDatas.reduce(0, { (initial, library) -> Int in
            return initial + library.usedSeats
        })
    }
    
    public var availableSeatsInScienceCampus: Int? {
        let ids = LibraryType.scienceCampusTypes().map({ $0.rawValue })
        let libraryDatas = libraries.filter { (libraryData) -> Bool in
            guard let libraryId = libraryData.libraryId else { return false }
            if ids.contains(libraryId) {
                return true
            } else {
                return false
            }
        }
        return libraryDatas.reduce(0, { (initial, library) -> Int in
            return initial + library.availableSeats
        })
    }
}

extension SummaryData: PercentagePresentable {
    public var availablePercentage: Float {
        guard totalSeats != 0 else { return 0 }
        guard let availableSeats = availableSeats, let totalSeats = totalSeats else { return 0 }
        return Float(availableSeats) / Float(totalSeats)
    }
    
    public var occupiedPercentage: Float {
        guard totalSeats != 0 else { return 0 }
        guard let usedSeats = usedSeats, let totalSeats = totalSeats else { return 0 }
        return Float(usedSeats) / Float(totalSeats)
    }
    
    public var availablePercentageInLiberalArtCampus: Float {
        guard totalSeatsInLiberalArtCampus != 0 else { return 0 }
        guard let availableSeats = availableSeatsInLiberalArtCampus, let totalSeats = totalSeatsInLiberalArtCampus else { return 0 }
        return Float(availableSeats) / Float(totalSeats)
    }
    
    public var occupiedPercentageInLiberalArtCampus: Float {
        guard totalSeatsInLiberalArtCampus != 0 else { return 0 }
        guard let usedSeats = usedSeatsInLiberalArtCampus, let totalSeats = totalSeatsInLiberalArtCampus else { return 0 }
        return Float(usedSeats) / Float(totalSeats)
    }
    
    public var availablePercentageInScienceCampus: Float {
        guard totalSeatsInScienceCampus != 0 else { return 0 }
        guard let availableSeats = availableSeatsInScienceCampus, let totalSeats = totalSeatsInScienceCampus else { return 0 }
        return Float(availableSeats) / Float(totalSeats)
    }
    
    public var occupiedPercentageInScienceCampus: Float {
        guard totalSeatsInScienceCampus != 0 else { return 0 }
        guard let usedSeats = usedSeatsInScienceCampus, let totalSeats = totalSeatsInScienceCampus else { return 0 }
        return Float(usedSeats) / Float(totalSeats)
    }
}
