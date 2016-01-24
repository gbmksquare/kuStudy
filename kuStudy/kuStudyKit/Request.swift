//
//  Request.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias SuccessHandler = (json: JSON) -> Void
public typealias FailureHandler = (error: NSError) -> Void

public extension kuStudy {
    // MARK: Request
    public func requestInfoIfNeeded(errorHandler: (error: NSError?) -> Void) {
        let infoRealm = kuStudy.infoRealm()
        let results = infoRealm!.objects(LibraryInfoRecord.self)
        if results.count == 0 {
            kuStudy.requestInfo({ (json) -> Void in
                let libraries = json["content"]["libraries"].arrayValue
                let readingRooms = json["content"]["readingRooms"].arrayValue
                
                var libraryInfoRecords = [LibraryInfoRecord]()
                for library in libraries {
                    let record = LibraryInfoRecord()
                    record.id = library["id"].intValue
                    record.key = library["key"].stringValue
                    libraryInfoRecords.append(record)
                }
                for readingRoom in readingRooms {
                    let record = LibraryInfoRecord()
                    record.id = readingRoom["id"].intValue
                    record.key = readingRoom["key"].stringValue
                    libraryInfoRecords.append(record)
                }
                let infoRealm = kuStudy.infoRealm()
                for record in libraryInfoRecords {
                    try! infoRealm!.write({ () -> Void in
                        infoRealm!.add(record, update: true)
                    })
                }
                }, failure: { (error) -> Void in
                    errorHandler(error: error)
            })
        }
    }
    
    public class func requestInfo(success: SuccessHandler, failure: FailureHandler) {
        Alamofire.request(.GET, kuStudyAPI.Info.url)
        .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
        .responseJSON(completionHandler: { (response) -> Void in
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                success(json: json)
            case .Failure(let error):
                failure(error: error)
            }
        })
    }
    
    public class func requestSeatSummary(success: SuccessHandler, failure: FailureHandler) {
        Alamofire.request(.GET, kuStudyAPI.Summary.url)
        .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    success(json: json)
                case .Failure(let error):
                    failure(error: error)
                }
            })
    }
    
    public class func requestLibrarySeatSummary(id: Int, success: SuccessHandler, failure: FailureHandler) {
        Alamofire.request(.GET, kuStudyAPI.Library(id: id).url)
        .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    success(json: json)
                case .Failure(let error):
                    failure(error: error)
                }
            })
    }
    
    public class func requestReadingRoomSeatSummary(id: Int, success: SuccessHandler, failure: FailureHandler) {
        Alamofire.request(.GET, kuStudyAPI.ReadingRoom(id: id).url)
        .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    success(json: json)
                case .Failure(let error):
                    failure(error: error)
                }
            })
    }
}
