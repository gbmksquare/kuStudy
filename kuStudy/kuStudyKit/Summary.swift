//
//  Summary.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/12.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation

public struct Summary {
    public let libraries: [Library]
    
    // MARK: - Initializer
    public init() {
        libraries = []
    }
    
    public init(libraries: [Library]) {
        self.libraries = libraries
    }
}

public extension Summary {
    var totalSeats: Int { return libraries.reduce(0) { $0 + $1.totalSeats } }
    var accessibleSeats: Int { return libraries.reduce(0) { $0 + $1.accessibleSeats } }
    
    var repairingSeats: Int { return libraries.reduce(0) { $0 + $1.repairingSeats } }
    var inallotableSeats: Int { return libraries.reduce(0) { $0 + $1.inallotableSeats } }
    var disabledSeats: Int { return libraries.reduce(0) { $0 + $1.disabledSeats } }
    
    var useableSeats: Int { return libraries.reduce(0) { $0 + $1.useableSeats } }
    var occupiedSeats: Int { return libraries.reduce(0) { $0 + $1.occupiedSeats } }
    var availableSeats: Int { return useableSeats - occupiedSeats }
    
    var occupiedPercentage: Double {
        return Double(occupiedSeats) / Double(useableSeats)
    }
    
    var availablePercentage: Double {
        return Double(availableSeats) / Double(useableSeats)
    }
}

public extension Summary {
    func useableSeats(for campus: [LibraryType]) -> Int {
        return libraries
            .filter { campus.contains($0.type) }
            .reduce(0) { $0 + $1.useableSeats}
    }
    
    func occupiedSeats(for campus: [LibraryType]) -> Int {
        return libraries
            .filter { campus.contains($0.type) }
            .reduce(0) { $0 + $1.occupiedSeats}
    }
    
    func availableSeats(for campus: [LibraryType]) -> Int {
        return libraries
            .filter { campus.contains($0.type) }
            .reduce(0) { $0 + $1.availableSeats}
    }
    
    func occupiedPercentage(for campus: [LibraryType]) -> Double {
        return Double(occupiedSeats(for: campus)) / Double(useableSeats(for: campus))
    }
    
    func availablePercentage(for campus: [LibraryType]) -> Double {
        return Double(availableSeats(for: campus)) / Double(useableSeats(for: campus))
    }
}

// MARK: - Extension
extension Summary: Summarizable {
    public var summary: String {
        return "Korea University Total: \(totalSeats.readable) Occupied: \(occupiedSeats.readable) Available \(availableSeats.readable)"
    }
}
