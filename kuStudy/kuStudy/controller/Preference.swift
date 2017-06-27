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
    fileprivate enum Key: String {
        case order = "libraryOrder"
        case widgetOrder = "todayExtensionOrder"
        case widgetHidden = "todayExtensionHidden"
        
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
    
    // MARK: - Initialization
    static let shared = Preference()
    
    init() {
        updateQuickActions()
        NotificationCenter.default.addObserver(self, selector: #selector(handle(preferenceChanged:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate lazy var preference = UserDefaults(suiteName: "group.com.gbmksquare.kuapps.kuStudy") ?? UserDefaults.standard
    
    // MARK: - Registration
    func registerDefault() {
        let libraryOrder = LibraryType.allTypes().map({ $0.rawValue })
        preference.register(defaults: [Preference.Key.order.name: libraryOrder,
                                     Preference.Key.widgetOrder.name: libraryOrder,
                                     Preference.Key.widgetHidden.name: []])
        preference.synchronize()
    }
    
    // MARK: - Notification
    @objc fileprivate func handle(preferenceChanged notification: Notification) {
        updateQuickActions()
    }
}

// MARK: - Quick action
extension Preference {
    fileprivate func updateQuickActions() {
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
