//
//  SocialAccount.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 14..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation

public struct SocialAccount: Codable {
    public enum SocialService: Int, Codable {
        case instagram, facebook
    }
    
    public let socialService: SocialService
    public let userId: String
}
