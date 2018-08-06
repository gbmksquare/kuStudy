//
//  SectorCellType.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 8. 4..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import Foundation

enum SectorCellType: Int {
    case classic, compact, veryCompact
    
    var name: String {
        switch self {
        case .classic: return Localizations.Label.CellType.Classic
        case .compact: return Localizations.Label.CellType.Compact
        case .veryCompact: return Localizations.Label.CellType.VeryCompact
        }
    }
    
    var preferredReuseIdentifier: String {
        switch self {
        case .classic: return "SectorCellType.classic"
        case .compact: return "SectorCellType.compact"
        case .veryCompact: return "SectorCellType.veryCompact"
        }
    }
    
    var cellClass: AnyClass {
        switch self {
        case .classic: return ClassicSectorCell.self
        case .compact: return CompactSectorCell.self
        case .veryCompact: return VeryCompactSectorCell.self
        }
    }
    
    static let allTypes: [SectorCellType] = [.classic, .compact, .veryCompact]
}
