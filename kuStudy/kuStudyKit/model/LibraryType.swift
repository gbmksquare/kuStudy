//
//  LibraryType.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 20..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation
import CoreLocation

public enum LibraryType: String, Codable {
    case centralLibrary = "1"
    case centralSquare = "2"
    case cdl = "3"
    case scienceLibrary = "4"
    case hanaSquare = "5"
    case law = "6"
    
    public var identifier: String {
        return rawValue
    }
    
    private var localizedKey: String {
        switch self {
        case .centralSquare: return "Library.Name.CentralSquare"
        case .centralLibrary: return "Library.Name.CentralLibrary"
        case .hanaSquare: return "Library.Name.HanaSquare"
        case .scienceLibrary: return "Library.Name.ScienceLibrary"
        case .cdl: return "Library.Name.Cdl"
        case .law: return "Library.Name.Law"
        }
    }
}

// MARK: - Category
public extension LibraryType {
    public static func allTypes() -> [LibraryType] {
        return [.centralLibrary, .centralSquare, .hanaSquare, .scienceLibrary, .cdl, .law]
    }
    
    public static func liberalArtCampusTypes() -> [LibraryType] {
        return [.centralLibrary, .centralSquare, .cdl, .law]
    }
    
    public static func scienceCampusTypes() -> [LibraryType] {
        return [.hanaSquare, .scienceLibrary]
    }
}

// MARK: - Name
public extension LibraryType {
    public var name: String {
        let framework = Bundle(for: kuStudy.self)
        return NSLocalizedString(localizedKey, bundle: framework, comment: "")
    }
    
    public var nameInAlternateLanguage: String {
        let framework = Bundle(for: kuStudy.self)
        if name.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            // `name` is English
            if let path = framework.path(forResource: "ko", ofType: "lproj"),
                let krBundle = Bundle(path: path) {
                return krBundle.localizedString(forKey: localizedKey, value: nil, table: nil)
            }
        } else {
            // `name` is not English
            if let path = framework.path(forResource: "Base", ofType: "lproj"),
                let baseBundle = Bundle(path: path) {
                return baseBundle.localizedString(forKey: localizedKey, value: nil, table: nil)
            }
        }
        return name
    }
    
    public var shortName: String {
        let framework = Bundle(for: kuStudy.self)
        return NSLocalizedString(localizedKey + ".Short", bundle: framework, comment: "")
    }
}

// MARK: - Map
public extension LibraryType {
    public var coordinate: CLLocationCoordinate2D {
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

// MARK: - API
internal extension LibraryType {
    internal var apiUrl: String {
        return "https://librsv.korea.ac.kr/libraries/lib-status/\(rawValue)"
    }
}
