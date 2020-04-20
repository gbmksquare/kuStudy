//
//  Library.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/01.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation

public struct Library {
    public let type: LibraryType
    public let studyAreas: [StudyArea]
}

public extension Library {
    var name: String {
        return type.name
    }
    
    var laptopCapable: Bool { return studyAreas.contains { $0.laptopCapable == true } }
    
    var totalSeats: Int { return studyAreas.reduce(0) { $0 + $1.totalSeats } }
    var accessibleSeats: Int { return studyAreas.reduce(0) { $0 + $1.accessibleSeats } }
    
    var repairingSeats: Int { return studyAreas.reduce(0) { $0 + $1.repairingSeats } }
    var inallotableSeats: Int { return studyAreas.reduce(0) { $0 + $1.inallotableSeats } }
    var disabledSeats: Int { return studyAreas.reduce(0) { $0 + $1.disabledSeats } }
    
    var useableSeats: Int { return studyAreas.reduce(0) { $0 + $1.useableSeats } }
    var occupiedSeats: Int { return studyAreas.reduce(0) { $0 + $1.occupiedSeats } }
    var availableSeats: Int { return useableSeats - occupiedSeats }
    
    var occupiedPercentage: Double {
        return Double(occupiedSeats) / Double(useableSeats)
    }
    
    var availablePercentage: Double {
        return Double(availableSeats) / Double(useableSeats)
    }
}

// MARK: - Extension
extension Library: Summarizable {
    public var summary: String {
"""
\(name)
\("total".localizedFromKit()): \(totalSeats.readable)
\("useable".localizedFromKit()): \(useableSeats.readable)
\("occupied".localizedFromKit()): \(occupiedSeats.readable)
\("available".localizedFromKit()): \(availableSeats.readable)
\("laptop".localizedFromKit()): \(laptopCapable ? "yes".localizedFromKit() : "no".localizedFromKit())
"""
    }
}
