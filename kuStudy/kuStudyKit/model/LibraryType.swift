//
//  LibraryType.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 20..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation
import CoreLocation

public enum LibraryType: String {
    // Old
//    case CentralLibrary = "3"
//    case CentralSquare = "1"
//    case HanaSquare = "5"
//    case ScienceLibrary = "26"
//    case CDL = "4"
    
    // New
    case CentralLibrary = "1"
    case CentralSquare = "2"
    case HanaSquare = "5"
    case ScienceLibrary = "4"
    case CDL = "3"
    
    internal static func convertToNewLibraryIdFromOld(id: String) -> String {
        switch id {
        case "3": return "1"
        case "1": return "2"
        case "5": return "5"
        case "26": return "4"
        case "4": return "3"
        default: return id
        }
    }
    
    public static func allTypes() -> [LibraryType] {
        return [.CentralLibrary, .CentralSquare, .HanaSquare, .ScienceLibrary, .CDL]
    }
    
    public static func liberalArtCampusTypes() -> [LibraryType] {
        return [.CentralLibrary, CentralSquare, .CDL]
    }
    
    public static func scienceCampusTypes() -> [LibraryType] {
        return [.HanaSquare, .ScienceLibrary]
    }
    
    private var localizedKey: String {
        switch self {
        case .CentralSquare: return "kuStudy.Library.Name.CentralSquare"
        case .CentralLibrary: return "kuStudy.Library.Name.CentralLibrary"
        case .HanaSquare: return "kuStudy.Library.Name.HanaSquare"
        case .ScienceLibrary: return "kuStudy.Library.Name.ScienceLibrary"
        case .CDL: return "kuStudy.Library.Name.Cdl"
        }
    }
    
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
    
    public var coordinate: CLLocationCoordinate2D {
        switch self {
        case .CentralSquare: return CLLocationCoordinate2D(latitude: 37.58851, longitude: 127.0337)
        case .CentralLibrary: return CLLocationCoordinate2D(latitude: 37.59075, longitude: 127.0341)
        case .HanaSquare: return CLLocationCoordinate2D(latitude: 37.58510, longitude: 127.0265)
        case .ScienceLibrary: return CLLocationCoordinate2D(latitude: 37.58459, longitude: 127.0266)
        case .CDL: return CLLocationCoordinate2D(latitude: 37.58944, longitude: 127.0344)
        }
    }
}
