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
    public let instagramId: String
    
    public var attributionString: String {
        if NSLocale.preferredLanguages().first?.hasPrefix("ko") == true {
            return "사진: \(association) \(name)"
        } else {
            return "Photography by \(name_en), \(association_en)"
        }
    }
    
    public var photos: [Photo] {
        return PhotoProvider.sharedProvider.photos.filter({ $0.photographer.name == name })
    }
}
