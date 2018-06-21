//
//  Preference+Key.swift
//  kuStudy
//
//  Created by BumMo Koo on 21/06/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import Foundation

extension Preference {
    enum Key: String {
        case preferenceVersion = "preferenceVersion"
        
        case order = "libraryOrder"
        case widgetOrder = "todayExtensionOrder"
        case widgetHidden = "todayExtensionHidden"
        
        case shouldAutoUpdate = "shouldAutoUpdate"
        case updateInterval = "updateInterval"
        
        case preferredMap = "preferredMap"
        
        case libraryCellType = "libraryCellType"
        case sectorCellType  = "sectorCellType"
        case widgetCellType = "widgetCellType"
        
        var name: String {
            return rawValue
        }
    }
}
