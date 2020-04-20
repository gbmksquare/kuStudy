//
//  StudyArea.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/03/28.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation

public struct StudyArea {
    public let identifier: Int
    public let name: String
    public let internationalName: String
    
    public let totalSeats: Int // All seats
    public let accessibleSeats: Int // Seats for disabled
    
    let laptopCapableRaw: String
    public var laptopCapable: Bool {
        return laptopCapableRaw == "Y" ? true : false
    }
    
    public let repairingSeats: Int // Seats in repair
    public let inallotableSeats: Int // 배정 불가
    public let disabledSeats: Int // 사용 불가
    
    public let useableSeats: Int // All seats - repairing - disabled - inallotable
    public let occupiedSeats: Int // Seats in use
    public var availableSeats: Int { // Empty seats that can be used
        return useableSeats - occupiedSeats
    }
    
    public var occupiedPercentage: Double {
        return Double(occupiedSeats) / Double(useableSeats)
    }
    
    public var availablePercentage: Double {
        return Double(availableSeats) / Double(useableSeats)
    }
}

// MARK: - Codable
extension StudyArea: Codable {
    enum CodingKeys: String, CodingKey {
        case identifier = "code"
        case name
        case internationalName = "nameEng"
        
        case laptopCapableRaw = "noteBookYN"
        
        case totalSeats = "cnt"
        case accessibleSeats = "disabled"
        
        case repairingSeats = "fix"
        case inallotableSeats = "normal"
        case disabledSeats = "unavailable"
        
        case useableSeats = "available"
        case occupiedSeats = "inUse"
    }
}

// MARK: - Extension
extension StudyArea: Summarizable {
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

/*
   "scCkMi": "10", // ?? check minute
 
   "bgImg": "/resources/image/layout/science/ghlib01_A.jpg",
   "previewImg": "/resources/image/appBg/science/1층 일반열람실 A.jpg",
 
   "miniMapImg": "/resources/image/minimap/science/5MiniMap_01.png",
   "maxMi": 240, // max minute
   "maxRenewMi": 240, // max renew minute
 
   "startTm": "0600",
   "endTm": "2300",
 
   "wkStartTm": "0600",
   "wkEndTm": "2300",
   "wkSetting": "NNNNNNN",
   "wkTimeUseSetting": "YNNNNNY",
   "wkRsrvUseYn": "Y",
 
   "fixedSeat": 0,
   "dayOff": null,
 
   "vaName": "과학도서관 1층 공사", // Vacation?
   "vaStartTime": "0000",
   "vaEndTime": "0000",
   "vaWkStartTime": "0000",
   "vaWkEndTime": "0000",
   "vaWkSetting": "YYYYYYY",
   "vaWkTimeUseSetting": "NNNNNNN",
   "vaWkRsrvUseYn": "Y"
*/
