//
//  SettingsMenu.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 7. 25..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import Foundation

enum SettingsMenu: Int {
    case autoUpdate = 103
    case autoUpdateInterval = 104
    case appLibraryOrder = 100
    case widgetLibraryOrder = 101
    case advanced = 300
    
    var tag: Int { return rawValue }
    
    var title: String {
        switch self {
        case .autoUpdate: return Localizations.Label.Settings.AutoUpdate
        case .autoUpdateInterval: return Localizations.Label.Settings.UpdateInterval
        case .appLibraryOrder: return Localizations.Label.Settings.LibraryOrder
        case .widgetLibraryOrder: return Localizations.Label.Settings.TodayOrder
        case .advanced: return Localizations.Label.Settings.Advanced
        }
    }
    
    static let sectionTitles: [String?] = [Localizations.Label.Settings.UpdateHeader,
                                           Localizations.Label.Settings.GeneralHeader,
                                           Localizations.Label.Settings.WidgetHeader,
                                           Localizations.Label.Settings.Advanced]
    static let sectionFooters: [String?] = [nil,
                                            nil,
                                            nil,
                                            nil]
    
    static let layout: [[SettingsMenu]] = [
        [.autoUpdate, .autoUpdateInterval],
        [.appLibraryOrder],
        [.widgetLibraryOrder],
        [.advanced]
    ]
}
