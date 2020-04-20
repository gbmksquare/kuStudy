//
//  SettingsMenu.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 7. 25..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import Foundation

enum SettingsOptions: Int {
    case appLibraryOrder
    case widgetLibraryOrder
    case advanced
    
    // MARK: - Value
    var tag: Int { return rawValue }
    
    var title: String {
        switch self {
        case .appLibraryOrder: return Localizations.Label.Settings.LibraryOrder
        case .widgetLibraryOrder: return Localizations.Label.Settings.TodayOrder
        case .advanced: return Localizations.Label.Settings.Advanced
        }
    }
    
    // MARK: - Layout
    static let layout: [SettingsSection] = [
        SettingsSection(header: Localizations.Label.Settings.GeneralHeader,
                footer: nil,
                rows: [
                    SettingsRow(menu: .appLibraryOrder)
        ]),
        SettingsSection(header: Localizations.Label.Settings.WidgetHeader,
                footer: nil,
                rows: [
                    SettingsRow(menu: .widgetLibraryOrder)
        ]),
    ]
}

struct SettingsSection {
    let header: String?
    let footer: String?
    let rows: [SettingsRow]
}

struct SettingsRow {
    let menu: SettingsOptions
}
