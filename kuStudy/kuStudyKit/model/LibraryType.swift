//
//  LibraryType.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 20..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public enum LibraryType: Int {
    case CentralSquare = 1
    case CentralLibrary = 3
    case HanaSquare = 5
    case ScienceLibrary = 26
    case CDL = 4
    
    public static func allTypes() -> [LibraryType] {
        return [.CentralSquare, .CentralLibrary, .HanaSquare, .ScienceLibrary, .CDL]
    }
    
    public var name: String {
        switch self {
        case .CentralSquare: return "중앙광장"
        case .CentralLibrary: return "중앙도서관"
        case .HanaSquare: return "하나스퀘어"
        case .ScienceLibrary: return "과학도서관"
        case .CDL: return "백주년기념관"
        }
    }
}
