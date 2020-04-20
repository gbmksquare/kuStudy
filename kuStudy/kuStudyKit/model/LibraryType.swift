//
//  LibraryType.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 20..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation
import CoreLocation

public enum LibraryType: String, Codable, CaseIterable {
    case centralLibrary = "1"
    case centralSquare = "2"
    case cdl = "3"
    case scienceLibrary = "4"
    case hanaSquare = "5"
    case law = "6"
    
    public var identifier: String {
        return rawValue
    }
    
    private var localizationKey: String {
        switch self {
        case .centralSquare: return "library.cs"
        case .centralLibrary: return "library.cl"
        case .hanaSquare: return "library.hana"
        case .scienceLibrary: return "library.science"
        case .cdl: return "library.cdl"
        case .law: return "library.law"
        }
    }
}

// MARK: - Category
public extension LibraryType {
    static var all: [LibraryType] {
        return [.centralLibrary, .centralSquare, .hanaSquare, .scienceLibrary, .cdl, .law]
    }
    
    static var liberalArtCampus: [LibraryType] {
        return [.centralLibrary, .centralSquare, .cdl, .law]
    }
    
    static var scienceCampus: [LibraryType] {
        return [.hanaSquare, .scienceLibrary]
    }
}

// MARK: - Web
public extension LibraryType {
    var url: URL {
        return URL(string: "https://librsv.korea.ac.kr/?lib=\(rawValue)")!
    }
}


// MARK: - Map
public extension LibraryType {
    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .centralSquare: return CLLocationCoordinate2D(latitude: 37.58851, longitude: 127.0337)
        case .centralLibrary: return CLLocationCoordinate2D(latitude: 37.59075, longitude: 127.0341)
        case .hanaSquare: return CLLocationCoordinate2D(latitude: 37.58510, longitude: 127.0265)
        case .scienceLibrary: return CLLocationCoordinate2D(latitude: 37.58459, longitude: 127.0266)
        case .cdl: return CLLocationCoordinate2D(latitude: 37.58944, longitude: 127.0344)
        case .law: return CLLocationCoordinate2D(latitude: 37.5907397, longitude: 127.0319772)
        }
    }
}

// MARK: - Name
public extension LibraryType {
    var name: String {
        let framework = Bundle(for: DataManager.self)
        return NSLocalizedString(localizationKey, bundle: framework, comment: "")
    }
    
    var nameInAlternateLanguage: String {
        let framework = Bundle(for: DataManager.self)
        if name.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            // `name` is English
            if let path = framework.path(forResource: "ko", ofType: "lproj"),
                let krBundle = Bundle(path: path) {
                return krBundle.localizedString(forKey: localizationKey, value: nil, table: nil)
            }
        } else {
            // `name` is not English
            if let path = framework.path(forResource: "Base", ofType: "lproj"),
                let baseBundle = Bundle(path: path) {
                return baseBundle.localizedString(forKey: localizationKey, value: nil, table: nil)
            }
        }
        return name
    }
}
