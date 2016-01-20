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

public typealias CompletionHandler = (json: JSON?, error: NSError?) -> Void

public extension kuStudy {
    // MARK: Request
    public func requestInfoIfNeeded(errorHandler: (error: NSError?) -> Void) {
        let infoRealm = kuStudy.infoRealm()
        let results = infoRealm!.objects(LibraryInfoRecord.self)
        if results.count == 0 {
            kuStudy().requestInfo { (json, error) -> Void in
                if let json = json {
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
                } else {
                    errorHandler(error: error)
                }
            }
        }
    }
    
    public func requestInfo(handler: CompletionHandler) {
        Alamofire.request(.GET, kuStudyAPI.Info.url)
        .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
        .responseJSON(completionHandler: { (response) -> Void in
            switch response.result {
            case .Success(let value):
                self.handleResponseObject(value, error: nil, handler: handler)
            case .Failure(_):
                break
            }
        })
    }
    
    public func requestSummary(handler: CompletionHandler) {
        Alamofire.request(.GET, kuStudyAPI.Summary.url)
        .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    self.handleResponseObject(value, error: nil, handler: handler)
                case .Failure(_):
                    break
                }
            })
    }
    
    public func requestLibrary(id: Int, handler: CompletionHandler) {
        Alamofire.request(.GET, kuStudyAPI.Library(id: id).url)
        .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    self.handleResponseObject(value, error: nil, handler: handler)
                case .Failure(_):
                    break
                }
            })
    }
    
    public func requestReadingRoom(id: Int, handler: CompletionHandler) {
        Alamofire.request(.GET, kuStudyAPI.ReadingRoom(id: id).url)
        .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    self.handleResponseObject(value, error: nil, handler: handler)
                case .Failure(_):
                    break
                }
            })
    }
    
    // MARK: Helper
    private func handleResponseObject(responseObject: AnyObject?, error: NSError?, handler: CompletionHandler) {
        if let responseObject = responseObject as? [String: AnyObject] {
            let json = JSON(responseObject)
            handler(json: json, error: error)
        } else {
            handler(json: nil, error: error)
        }
    }
}
