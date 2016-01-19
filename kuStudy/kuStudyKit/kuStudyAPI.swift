//
//  kuStudyAPI.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation

protocol API {
    var baseUrl: String { get }
}

enum kuStudyAPI: API {
    // TODO: Use HTTPS instead of HTTP
    var baseUrl: String { return "https://api.gbmksquare.com/kuapps/kustudy/v1" }
    
    case Info
    case Summary
    case Library(id: Int)
    case ReadingRoom(id: Int)
}

extension kuStudyAPI {
    var url: String {
        switch self {
        case .Info: return baseUrl + "/info"
        case .Summary: return baseUrl + "/summary"
        case .Library(let id): return baseUrl + "/library/\(id)"
        case .ReadingRoom(let id): return baseUrl + "/readingroom/\(id)"
        }
    }
}
