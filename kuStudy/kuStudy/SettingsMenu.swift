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
    case libraryCellType = 201
    case sectorCellType = 202
    case appStoreReview = 999
    case mediaProvider = 901
    case openSource = 900
    case donate = 1004
    
    var tag: Int { return rawValue }
    
    var title: String {
        switch self {
        case .autoUpdate: return Localizations.Label.Settings.AutoUpdate
        case .autoUpdateInterval: return Localizations.Label.Settings.UpdateInterval
        case .appLibraryOrder: return Localizations.Label.Settings.LibraryOrder
        case .widgetLibraryOrder: return Localizations.Label.Settings.TodayOrder
        case .libraryCellType: return Localizations.Label.Settings.LibraryCellType
        case .sectorCellType: return Localizations.Label.Settings.SectorCellType
        case .appStoreReview: return Localizations.Label.Settings.AppStoreReview
        case .mediaProvider: return Localizations.Label.Settings.MediaProvider
        case .openSource: return Localizations.Label.Settings.OpenSource
        case .donate: return Localizations.Label.Settings.TipJar
        }
    }
    
    static let sectionTitles: [String?] = [Localizations.Label.Settings.UpdateHeader,
                                           Localizations.Label.Settings.GeneralHeader,
                                           Localizations.Label.Settings.WidgetHeader,
                                           Localizations.Label.Settings.FeedbackHeader,
                                           Localizations.Label.Settings.AboutHeader]
    static let sectionFooters: [String?] = [nil,
                                            nil,
                                            nil,
                                            Localizations.Label.Settings.ReviewFooter,
                                            nil]
    
    #if DEBUG
    static let layout: [[SettingsMenu]] = [
        [.autoUpdate, .autoUpdateInterval],
        [.appLibraryOrder, .libraryCellType, .sectorCellType],
        [.widgetLibraryOrder],
        [.appStoreReview],
        [.mediaProvider, .openSource, .donate]
    ]
    #else
    static let layout: [[SettingsMenu]] = [
        [.autoUpdate, .autoUpdateInterval],
        [.appLibraryOrder, .libraryCellType, .sectorCellType],
        [.widgetLibraryOrder],
        [.appStoreReview],
        [.mediaProvider, .openSource]]
    #endif
}
