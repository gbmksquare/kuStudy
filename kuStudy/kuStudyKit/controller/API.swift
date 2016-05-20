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

public typealias FailureHandler = (error: NSError) -> Void

private let apiUrl = "http://cdl.korea.ac.kr/DLMS_KOU_INTRO/api/seatStatusList.do"

public extension kuStudy {
    public class func requestAllLibraryData(onLibrarySuccess onLibrarySuccess: ((libraryData: LibraryData) -> ())?, onFailure: FailureHandler?, onCompletion: (() -> ())?) {
        let libraryTypes = LibraryType.allTypes()
        var completeCount = 0
        for type in libraryTypes {
            let libraryId = type.rawValue
            requestLibraryData(libraryId: libraryId,
               onSuccess: { (libraryData) in
                    onLibrarySuccess?(libraryData: libraryData)
                    completeCount += 1
                    if completeCount == libraryTypes.count {
                        onCompletion?()
                    }
                },
               onFailure: { (error) in
                    onFailure?(error: error)
                    completeCount += 1
                    if completeCount == libraryTypes.count {
                        onCompletion?()
                    }
            })
        }
    }
    
    public class func requestLibraryData(libraryId libraryId: Int, onSuccess: (libraryData: LibraryData) -> (), onFailure: FailureHandler?) {
        let headers = ["Accept": "application/javascript"]
        let body = ["libNo": libraryId]
        Alamofire.request(.POST, apiUrl, parameters: body, encoding: .URL, headers: headers)
            .responseObject { (response: Response<LibraryData, NSError>) in
                switch response.result {
                case .Success(let libraryData):
                    onSuccess(libraryData: libraryData)
                case .Failure(let error):
                    onFailure?(error: error)
                }
        }
    }
}
