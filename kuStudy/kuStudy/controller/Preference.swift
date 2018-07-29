//
//  Preference.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 6. 27..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import kuStudyKit

class Preference {
    var preferenceVersion: Int {
        get { return preference.integer(forKey: Preference.Key.preferenceVersion.name) }
        set {
            preference.setValue(newValue, forKey: Preference.Key.preferenceVersion.name)
            preference.synchronize()
        }
    }
    
    var libraryOrder: [String] {
        get { return preference.array(forKey: Preference.Key.order.name) as? [String] ?? [] }
        set {
            preference.setValue(newValue, forKey: Preference.Key.order.name)
            preference.synchronize()
        }
    }
    
    var widgetLibraryOrder: [String] {
        get { return preference.array(forKey: Preference.Key.widgetOrder.name) as? [String] ?? [] }
        set {
            preference.setValue(newValue, forKey: Preference.Key.widgetOrder.name)
            preference.synchronize()
        }
    }
    
    var widgetLibraryHidden: [String] {
        get { return preference.array(forKey: Preference.Key.widgetHidden.name) as? [String] ?? [] }
        set {
            preference.setValue(newValue, forKey: Preference.Key.widgetHidden.name)
            preference.synchronize()
        }
    }
    
    var shouldAutoUpdate: Bool {
        get { return preference.bool(forKey: Preference.Key.shouldAutoUpdate.name) }
        set {
            preference.setValue(newValue, forKey: Preference.Key.shouldAutoUpdate.name)
            preference.synchronize()
        }
    }
    
    var updateInterval: Double {
        get { return preference.double(forKey: Preference.Key.updateInterval.name) }
        set {
            preference.setValue(newValue, forKey: Preference.Key.updateInterval.name)
            preference.synchronize()
        }
    }
    
    var preferredMap: MapType {
        get {
            let int = preference.integer(forKey: Preference.Key.preferredMap.name)
            return MapType(rawValue: int) ?? MapType.apple
        }
        set {
            preference.setValue(newValue.rawValue, forKey: Preference.Key.preferredMap.name)
            preference.synchronize()
        }
    }
    
    var libraryCellType: LibraryCellType  {
        get {
            let int = preference.integer(forKey: Preference.Key.libraryCellType.name)
            return LibraryCellType(rawValue: int) ?? LibraryCellType.classic
        }
        set  {
            preference.setValue(newValue.rawValue, forKey: Preference.Key.libraryCellType.name)
            preference.synchronize()
        }
    }
    
//    var sectorCellType: SectorCellType {
//        get {
//            let int = preference.integer(forKey: Preference.Key.sectorCellType.name)
//            return SectorCellType(rawValue: int) ?? SectorCellType.classic
//        }
//        set {
//            preference.setValue(newValue.rawValue, forKey: Preference.Key.sectorCellType.name)
//            preference.synchronize()
//        }
//    }
//    
//    var widgetCellType: WidgetCellType {
//        get {
//            let int = preference.integer(forKey: Preference.Key.widgetCellType.name)
//            return WidgetCellType(rawValue: int) ?? WidgetCellType.classic
//        }
//        set {
//            preference.setValue(newValue.rawValue, forKey: Preference.Key.widgetCellType.name)
//            preference.synchronize()
//        }
//    }
    
    // MARK: - Initialization
    static let shared = Preference()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handle(preferenceChanged:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var preference = UserDefaults(suiteName: "group.com.gbmksquare.kuapps.kuStudy") ?? UserDefaults.standard
    
    // MARK: - Registration
    func setup() {
        updateQuickActions()
        migrateIfNeeded()
        registerDefault()
    }
    
    private func registerDefault() {
        let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
        preference.register(defaults: [Preference.Key.order.name: libraryOrder,
                                       Preference.Key.widgetOrder.name: libraryOrder,
                                       Preference.Key.widgetHidden.name: [],
                                       Preference.Key.preferredMap.name: MapType.apple.rawValue,
                                       Preference.Key.preferenceVersion.name: 5,
                                       Preference.Key.shouldAutoUpdate.name: true,
                                       Preference.Key.updateInterval.name: 60,
                                       Preference.Key.libraryCellType.name: LibraryCellType.classic.rawValue])
//        Preference.Key.sectorCellType.name: SectorCellType.classic.rawValue,
//        Preference.Key.widgetCellType.name: WidgetCellType.classic.rawValue
        preference.synchronize()
    }
    
    private func migrateIfNeeded() {
        if preferenceVersion <= 3 {
            preference.removeObject(forKey: Preference.Key.order.name)
            preference.removeObject(forKey: Preference.Key.widgetOrder.name)
            preference.removeObject(forKey: Preference.Key.widgetHidden.name)
        }
        if preferenceVersion == 4 {
            libraryOrder += [LibraryType.law.rawValue]
            widgetLibraryOrder += [LibraryType.law.rawValue]
        }
        preferenceVersion = 5
    }
    
    // MARK: - Action
    func resetLibraryOrder() {
        Preference.shared.libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
    }
    
    func resetWidgetLibraryOrder() {
        Preference.shared.widgetLibraryOrder = LibraryType.allTypes().map({ $0.rawValue })
        Preference.shared.widgetLibraryHidden = []
    }
    
    // MARK: - Notification
    @objc private func handle(preferenceChanged notification: Notification) {
        updateQuickActions()
    }
}

// MARK: - Quick action
extension Preference {
    private func updateQuickActions() {
        guard let orderedLibraryIds = preference.array(forKey: Preference.Key.order.rawValue) as? [String] else { return }
        let libraryTypes = LibraryType.allTypes()
        
        let actionType = "com.gbmksquare.kuapps.kucourse.LibraryAction"
        
        let icon = UIApplicationShortcutIcon(templateImageName: "187-pencil")
        var quickActionItems = [UIMutableApplicationShortcutItem]()
        for libraryId in orderedLibraryIds {
            let libraryType = libraryTypes.filter({ $0.rawValue == libraryId }).first!
            let item = UIMutableApplicationShortcutItem(type: actionType, localizedTitle: libraryType.name, localizedSubtitle: nil, icon: icon, userInfo: ["libraryId": libraryId])
            quickActionItems.append(item)
        }
        
        UIApplication.shared.shortcutItems = quickActionItems
    }
}
