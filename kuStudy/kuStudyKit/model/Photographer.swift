//
//  Photographer.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 10..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public struct Photographer {
    let id: Int
    public let name: String
    public let name_en: String
    public let association: String
    public let association_en: String
    
    public var attributionString: String {
        if NSLocale.preferredLanguages().first?.hasPrefix("ko") == true {
            return "\(association) \(name)"
        } else {
            return "Photography by \(association_en) \(name_en)"
        }
    }
}
