//
//  LibraryResponse.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/03/28.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation

struct LibraryResponse {
    let code: Int
    let message: String
    let data: [StudyArea]
}

// MARK: - Codable
extension LibraryResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case data
    }
}
