//
//  Creator.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 8. 13..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation

public struct Creator: Equatable {
    public enum SocialAccount {
        case website(address: String)
        case instagram(id: String)
        case facebook(id: String)
        case linkedin(id: String)
    }
    
    public let identifier: String?
    public let name: String
    public let association: String?
    public let socialId: [SocialAccount]?
    
    public static func ==(lhs: Creator, rhs: Creator) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
