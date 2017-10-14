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
    enum MapType: Int {
        case apple, google
    }
    
    private enum Key: String {
        case order = "libraryOrder"
        case widgetOrder = "todayExtensionOrder"
        case widgetHidden = "todayExtensionHidden"
        case preferredMap = "preferredMap"
        case preferenceVersion = "preferenceVersion"
        
        var name: String {
            return rawValue
        }
    }
    
    var libraryOrder: [String] {
        get {
            return preference.array(forKey: Preference.Key.order.name) as? [String] ?? []
        }
        set {
            preference.setValue(newValue, forKey: Preference.Key.order.name)
            preference.synchronize()
        }
    }
    
    var widgetLibraryOrder: [String] {
        get {
            return preference.array(forKey: Preference.Key.widgetOrder.name) as? [String] ?? []
        }
        set {
            preference.setValue(newValue, forKey: Preference.Key.widgetOrder.name)
            preference.synchronize()
        }
    }
    
    var widgetLibraryHidden: [String] {
        get {
            return preference.array(forKey: Preference.Key.widgetHidden.name) as? [String] ?? []
        }
        set {
            preference.setValue(newValue, forKey: Preference.Key.widgetHidden.name)
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
    
    var preferenceVersion: Int {
        get {
            return preference.integer(forKey: Preference.Key.preferenceVersion.name)
        }
        set {
            preference.setValue(newValue, forKey: Preference.Key.preferenceVersion.name)
            preference.synchronize()
        }
    }
    
    // MARK: - Initialization
    static let shared = Preference()
    
    init() {
        clearOldValuesIfNecessary()
        updateQuickActions()
        NotificationCenter.default.addObserver(self, selector: #selector(handle(preferenceChanged:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var preference = UserDefaults(suiteName: "group.com.gbmksquare.kuapps.kuStudy") ?? UserDefaults.standard
    
    // MARK: - Registration
    func registerDefault() {
        let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
        preference.register(defaults: [Preference.Key.order.name: libraryOrder,
                                       Preference.Key.widgetOrder.name: libraryOrder,
                                       Preference.Key.widgetHidden.name: [],
                                       Preference.Key.preferredMap.name: MapType.apple.rawValue,
                                       Preference.Key.preferenceVersion.name: 3])
        preference.synchronize()
    }
    
    private func clearOldValuesIfNecessary() {
        if preferenceVersion <= 3 {
            preference.removeObject(forKey: Preference.Key.order.name)
            preference.removeObject(forKey: Preference.Key.widgetOrder.name)
            preference.removeObject(forKey: Preference.Key.widgetHidden.name)
            preferenceVersion = 4
        }
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
