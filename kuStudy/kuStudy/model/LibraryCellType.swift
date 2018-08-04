//
//  LibraryCellType.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 7. 29..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import Foundation

enum LibraryCellType: Int {
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
        case .classic: return "LibraryCellType.classic"
        case .compact: return "LibraryCellType.compact"
        case .veryCompact: return "LibraryCellType.veryCompact"
        }
    }
    
    var cellClass: AnyClass {
        switch self {
        case .classic: return ClassicLibraryCell.self
        case .compact: return CompactLibraryCell.self
        case .veryCompact: return VeryCompactLibraryCell.self
        }
    }
    
    static let allTypes: [LibraryCellType] = [.classic, .compact, .veryCompact]
}
