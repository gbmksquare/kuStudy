//
//  Preference.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 6. 27..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import kuStudyKit

final class Preference {
    enum Key: String {
        case preferenceVersion = "preferenceVersion"
        
        case order = "libraryOrder"
        
        var name: String {
            return rawValue
        }
    }
    
    static let shared = Preference()
    private lazy var preference = UserDefaults(suiteName: "group.com.gbmksquare.kuapps.kuStudy") ?? UserDefaults.standard
    
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
    
    // MARK: - Initialization
    private init() {
        
    }
    
    deinit {
        
    }
    
    // MARK: - Registration
    func setup() {
        migrateIfNeeded()
        registerDefault()
    }
    
    private func registerDefault() {
        let libraryOrder = LibraryType.all.map({ $0.rawValue })
        preference.register(defaults: [Preference.Key.order.name: libraryOrder,
                                       Preference.Key.preferenceVersion.name: 6])
        preference.synchronize()
    }
    
    private func migrateIfNeeded() {
        if preferenceVersion <= 3 {
            preference.removeObject(forKey: Preference.Key.order.name)
        }
        if preferenceVersion == 4 {
            libraryOrder += [LibraryType.law.rawValue]
        }
        if preferenceVersion == 5 {
            
        }
        preferenceVersion = 6
    }
    
    // MARK: - Action
    func resetLibraryOrder() {
        Preference.shared.libraryOrder = LibraryType.all.map({ $0.rawValue })
    }
}
