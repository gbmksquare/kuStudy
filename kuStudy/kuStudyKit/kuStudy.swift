//
//  kuStudy.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import KeychainAccess

public class kuStudy {
    // MARK: Initialization
    public init() {
        
    }
    
    // MARK: Authentification
    var authId: String {
        get {
            let keychain = Keychain(service: kuStudyKeychainService, accessGroup: kuStudyKeychainAccessGroup)
            if let id = keychain[kuStudyKeychainIdKey] {
                return id
            } else {
                return ""
            }
        }
        set {
            let keychain = Keychain(service: kuStudyKeychainService, accessGroup: kuStudyKeychainAccessGroup)
            keychain[kuStudyKeychainIdKey] = newValue
        }
    }
    
    var authPassword: String {
        get {
            let keychain = Keychain(service: kuStudyKeychainService, accessGroup: kuStudyKeychainAccessGroup)
            if let password = keychain[kuStudyKeychainPasswordKey] {
                return password
            } else {
                return ""
            }
        }
        set {
            let keychain = Keychain(service: kuStudyKeychainService, accessGroup: kuStudyKeychainAccessGroup)
            keychain[kuStudyKeychainPasswordKey] = newValue
        }
    }
}
