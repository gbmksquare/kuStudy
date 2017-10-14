//
//  Artist.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 14..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation

public struct Artist: Codable, Equatable {
    internal let identifier: String
    public let name: String
    public let association: String
    public let socialAccounts: [SocialAccount]
    
    public static func ==(lhs: Artist, rhs: Artist) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

internal let artistsPreset = """
[
    {
        "identifier": "GBM920C5-54F6-42DD-9069-5ED5307D0DEC",
        "name": "구범모",
        "association": "일상다반사",
        "socialAccounts":
        [
            {
                "socialService": 0,
                "userId": "gbmksquare"
            },
            {
                "socialService": 1,
                "userId": "gbmksquare"
            }
        ]
    },
    {
        "identifier": "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
        "name": "배경동",
        "association": "일상다반사",
        "socialAccounts":
        [
            {
                "socialService": 0,
                "userId": "kyungdong.bae"
            }
        ]
    },
    {
        "identifier": "LJY4A5F7-366B-4D31-B9A2-88B323C68561",
        "name": "이준영",
        "association": "일상다반사",
        "socialAccounts":
        [
            {
                "socialService": 0,
                "userId": "leecandoitzz"
            }
        ]
    },
    {
        "identifier": "LOVEF079-E23D-43F0-8101-B30A1EE93AA6",
        "name": "전사랑",
        "association": "일상다반사",
        "socialAccounts":
        [
            {
                "socialService": 0,
                "userId": "j_lovely"
            }
        ]
    },
    {
        "identifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "name": "이영준",
        "association": "일상다반사",
        "socialAccounts":
        [
            {
                "socialService": 0,
                "userId": "rastignac9"
            }
        ]
    },
    {
        "identifier": "SOMBC392-5F74-44C5-B9D0-655A5FCDBF7C",
        "name": "전소미",
        "association": "일상다반사",
        "socialAccounts":
        [
            {
                "socialService": 0,
                "userId": "som_gallery"
            }
        ]
    },
]
"""
