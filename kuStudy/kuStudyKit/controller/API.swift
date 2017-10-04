//
//  API.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 20..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

public typealias FailureHandler = (_ error: Error) -> Void

private let apiUrl = "http://librsv.korea.ac.kr/DLMS_KOU_INTRO/api/seatStatusList.do"

public extension kuStudy {
    public class func requestSummaryData(onLibrarySuccess: ((_ libraryData: LibraryData) -> ())?, onFailure: FailureHandler?, onCompletion: ((_ summaryData: SummaryData) -> ())?) {
        let libraryTypes = 1...5 // LibraryType.allTypes()
        var completeCount = 0
        let summaryData = SummaryData()
        for type in libraryTypes {
//            let libraryId = type.rawValue
            requestLibraryData(libraryId: "\(type)",
               onSuccess: { (libraryData) in
                    onLibrarySuccess?(libraryData)
                    summaryData.libraries.append(libraryData)
                    completeCount += 1
                    if completeCount == libraryTypes.count {
                        onCompletion?(summaryData)
                    }
                },
               onFailure: { (error) in
                    onFailure?(error)
                    completeCount += 1
                    if completeCount == libraryTypes.count {
                        onCompletion?(summaryData)
                    }
            })
        }
    }
    
    public class func requestLibraryData(libraryId: String, onSuccess: @escaping (_ libraryData: LibraryData) -> (), onFailure: FailureHandler?) {
//        let headers = ["Accept": "application/javascript"]
//        let body = ["libNo": libraryId]
//        Alamofire.request(apiUrl, method: .post, parameters: body, encoding: URLEncoding.default, headers: headers)
//            .responseObject { (response: DataResponse<LibraryData>) in
//                switch response.result {
//                case .success(let libraryData):
//                    onSuccess(libraryData)
//                case .failure(let error):
//                    onFailure?(error)
//                }
//        }
        
        Alamofire.request("https://librsv.korea.ac.kr/libraries/lib-status/" + libraryId, method: .get)
            .responseObject { (response: DataResponse<LibraryData>) in
                switch response.result {
                case .success(let libraryData):
                    libraryData.libraryId = libraryId
                    onSuccess(libraryData)
                case .failure(let error):
                    onFailure?(error)
                }
        }
    }
}
