//
//  Artist.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 14..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation

@available(*, deprecated)
struct Artist: Equatable {
    let identifier: String
    let name: String
    let association: String
    let socialAccounts: [SocialAccount]
    
    static func ==(lhs: Artist, rhs: Artist) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension MediaManager {
    static let artists: [Artist] = [
        Artist(identifier: "GBM920C5-54F6-42DD-9069-5ED5307D0DEC", name: "구범모", association: "일상다반사",
               socialAccounts: [
                SocialAccount(socialService: .facebook, userId: "gbmksquare"),
                SocialAccount(socialService: .instagram, userId: "gbmksquare")
            ]),
        Artist(identifier: "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0", name: "배경동", association: "일상다반사",
               socialAccounts: [
                SocialAccount(socialService: .instagram, userId: "kyungdong.bae")
            ]),
        Artist(identifier: "LJY4A5F7-366B-4D31-B9A2-88B323C68561", name: "이준영", association: "일상다반사",
               socialAccounts: [
                SocialAccount(socialService: .instagram, userId: "leecandoitzz")
            ]),
        Artist(identifier: "LOVEF079-E23D-43F0-8101-B30A1EE93AA6", name: "전사랑", association: "일상다반사",
               socialAccounts: [
                SocialAccount(socialService: .instagram, userId: "j_lovely")
            ]),
        Artist(identifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4", name: "이영준", association: "일상다반사",
               socialAccounts: [
                SocialAccount(socialService: .instagram, userId: "rastignac9")
            ]),
        Artist(identifier: "SOMBC392-5F74-44C5-B9D0-655A5FCDBF7C", name: "전소미", association: "일상다반사",
               socialAccounts: [
                SocialAccount(socialService: .instagram, userId: "som_gallery")
            ]),
        Artist(identifier: "ALH3EE4D-3D68-452C-95B9-C18A9EDF5ED2", name: "이동렬", association: "일상다반사",
               socialAccounts: [
                SocialAccount(socialService: .instagram, userId: "rnscrlee7291")
            ]),
        ]
}
