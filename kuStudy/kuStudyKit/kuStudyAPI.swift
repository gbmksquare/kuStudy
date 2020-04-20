//
//  kuStudyAPI.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/03/28.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation
import Alamofire
import os.log

enum kuStudyAPI {
    static let baseURL = "https://librsv.korea.ac.kr"
    static let libraryEndPoint = "/libraries/lib-status"
}

extension kuStudyAPI {
    static func reqeustData(for libraryType: LibraryType,
                            _ handler: @escaping (Result<Library, Error>) -> Void) {
        let url = baseURL + libraryEndPoint + "/\(libraryType.identifier)"
        AF.request(url, method: .get)
            .responseDecodable(of: LibraryResponse.self)
            { (response) in
                switch response.result {
                case let .success(response):
                    os_log(.debug, log: .api, "API Success : %{PRIVATE}@", #function)
                    let library = Library(type: libraryType,
                            studyAreas: response.data)
                    handler(Result { library })
                case let .failure(error):
                    os_log(.debug, log: .api, "API Failure : %{PRIVATE}@ - %{PUBLIC}@", #function, error.localizedDescription)
                    handler(Result { throw error })
                }
        }
    }
}
