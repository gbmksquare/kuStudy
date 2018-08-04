//
//  SectorCellType.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 8. 4..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import Foundation

enum SectorCellType: Int {
    case classic
    
    var name: String {
        switch self {
        case .classic: return Localizations.Label.CellType.Classic
        }
    }
    
    var preferredReuseIdentifier: String {
        switch self {
        case .classic: return "SectorCellType.classic"
        }
    }
    
    var cellClass: AnyClass {
        switch self {
        case .classic: return SectorCell.self
        }
    }
    
    static let allTypes: [SectorCellType] = [.classic]
}
