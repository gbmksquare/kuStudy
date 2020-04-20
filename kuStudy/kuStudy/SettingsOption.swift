//
//  SettingsMenu.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 7. 25..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import Foundation

enum SettingsOption: Int {
    case appIcon
    case appLibraryOrder
    case appSettings
    case linkStudyArea, linkLibrary, linkCalendar
    case writeReview
    case tipJar
    case version, terms, privacyPolicy, openSource
    
    // MARK: - Value
    var tag: Int { return rawValue }
    
    var title: String {
        switch self {
        case .appLibraryOrder: return "order".localized()
        case .appIcon: return "appIcon".localized()
        case .appSettings: return "externalSettings".localized()
        case .linkStudyArea: return "ku".localizedFromKit() + " " + "studyArea".localizedFromKit()
        case .linkLibrary: return "ku".localizedFromKit() + " " + "library".localized()
        case .linkCalendar: return "ku".localizedFromKit() + " " + "academicCalendar".localizedFromKit()
        case .writeReview: return "reviewApp".localized()
        case .tipJar: return "tipJar".localized()
        case .version: return "version".localized()
        case .terms: return "terms".localized()
        case .privacyPolicy: return "privacyPolicy".localized()
        case .openSource: return "openSource".localized()
        }
    }
    
    // MARK: - Layout
    static let layout: [SettingsSection] = [
        SettingsSection(header: "general".localized(),
                        footer: nil,
                        rows: [
                            .appIcon,
                            .appLibraryOrder
        ]),
        SettingsSection(header: "permission".localized(),
                        footer: nil,
                        rows: [
                            .appSettings
        ]),
        SettingsSection(header: "link".localized(),
                        footer: nil,
                        rows: [
                            .linkStudyArea, .linkLibrary, .linkCalendar
        ]),
        SettingsSection(header: "support".localized(),
                        footer: "reviewAppDescription".localized(),
                        rows: [
                            .writeReview, .tipJar
        ]),
        SettingsSection(header: "about".localized(),
                        footer: nil,
                        rows: [
                            .version,
                            .terms,
                            .privacyPolicy,
                            .openSource
        ])
    ]
}

struct SettingsSection {
    let header: String?
    let footer: String?
    let rows: [SettingsOption]
}
