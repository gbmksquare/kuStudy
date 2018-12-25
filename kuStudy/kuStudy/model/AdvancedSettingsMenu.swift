//
//  AdvancedSettingsMenu.swift
//  kuStudy
//
//  Created by BumMo Koo on 25/12/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import Foundation

enum AdvancedSettingsMenu: Int {
    case appIcon, libraryCellType, sectorCellType
    case openAppSettings
    case openLibrarySeatsLink, openLibraryLink, openAcademicCalendarLink
    case writeReview, bugReport, tipJar
    case version, thanksTo, privacyPolicy, openSource
    
    var tag: Int { return rawValue }
    
    var title: String {
        switch self {
        case .appIcon: return Localizations.Label.Settings.AppIcon
        case .libraryCellType: return Localizations.Label.Settings.LibraryCellType
        case .sectorCellType: return Localizations.Label.Settings.SectorCellType
        case .openAppSettings: return Localizations.Label.Settings.OpenSettings
        case .openLibrarySeatsLink: return Localizations.Label.Settings.OpenLibrarySeats
        case .openLibraryLink: return Localizations.Label.Settings.OpenLibrary
        case .openAcademicCalendarLink: return Localizations.Label.Settings.OpenAcademicCalendar
        case .writeReview: return Localizations.Label.Settings.AppStoreReview
        case .bugReport: return Localizations.Label.Settings.BugReport
        case .tipJar: return Localizations.Label.Settings.TipJar
        case .version: return Localizations.Label.Settings.Version
        case .thanksTo: return Localizations.Label.Settings.MediaProvider
        case .privacyPolicy: return Localizations.Label.Settings.PrivacyPolicy
        case .openSource: return Localizations.Label.Settings.OpenSource
        }
    }
    
    #if DEBUG
    static let layout: [(header: String?, footer: String?, menus:  [AdvancedSettingsMenu])] =
    [
        (Localizations.Label.Settings.Apperance, nil,
         [.appIcon, .libraryCellType, .sectorCellType]),
        (Localizations.Label.Settings.Permissions, nil,
         [.openAppSettings]),
        (Localizations.Label.Settings.Links, nil,
         [.openLibrarySeatsLink, .openLibraryLink, .openAcademicCalendarLink]),
        (Localizations.Label.Settings.Support, Localizations.Label.Settings.ReviewFooter,
         [.writeReview, .bugReport]),
        (Localizations.Label.Settings.About, nil,
         [.version, .thanksTo, .privacyPolicy, .openSource]),
    ]
    #else
    static let layout: [(header: String?, footer: String?, menus:  [AdvancedSettingsMenu])] =
        [
            (Localizations.Label.Settings.Apperance, nil,
             [.appIcon, .libraryCellType, .sectorCellType]),
            (Localizations.Label.Settings.Permissions, nil,
             [.openAppSettings]),
            (Localizations.Label.Settings.Links, nil,
             [.openLibrarySeatsLink, .openLibraryLink, .openAcademicCalendarLink]),
            (Localizations.Label.Settings.Support, Localizations.Label.Settings.ReviewFooter,
             [.writeReview, .bugReport, .tipJar]),
            (Localizations.Label.Settings.About, nil,
             [.version, .thanksTo, .privacyPolicy, .openSource]),
            (Localizations.Label.Settings.Debug, nil, [])
    ]
    #endif
}
