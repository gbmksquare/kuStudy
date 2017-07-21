//
//  LibraryType.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 20..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public enum LibraryType: String {
    case CentralLibrary = "3"
    case CentralSquare = "1"
    case HanaSquare = "5"
    case ScienceLibrary = "26"
    case CDL = "4"
    
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
}
