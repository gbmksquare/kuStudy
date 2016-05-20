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

@available(*, deprecated=1) public extension kuStudy {
    // MARK: Request
    @available(*, deprecated=1) public class func requestLibraryInfo(success: (libraries: [Library]) -> Void, failure: FailureHandler) {
        Alamofire.request(.GET, kuStudyAPI.Info.url)
            .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
            .responseJSON { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    let content = json["content"]
                    // Libraries
                    var libraries = [Library]()
                    let librariesJson = content["libraries"].arrayValue
                    for libraryJson in librariesJson {
                        let id = libraryJson["id"].intValue
                        let key = libraryJson["key"].stringValue
                        let library = Library(id: id, key: key, total: 0, available: 0)
                        libraries.append(library)
                    }
                    success(libraries: libraries)
                case .Failure(let error):
                    failure(error: error)
                }
        }
    }
    
    @available(*, deprecated=1) public class func requestSeatSummary(success: (summary: Summary, libraries: [Library]) -> Void, failure: FailureHandler) {
        Alamofire.request(.GET, kuStudyAPI.Summary.url)
        .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    let content = json["content"]
                    // Summary
                    let total = content["total"].intValue
                    let available = content["available"].intValue
                    let updateTime = content["time"].stringValue
                    let summary = Summary(total: total, available: available, time: updateTime)
                    // Library
                    let librariesJson = content["libraries"].arrayValue
                    var libraries = [Library]()
                    for libraryJson in librariesJson {
                        let id = libraryJson["id"].intValue
                        let key = libraryJson["key"].stringValue
                        let total = libraryJson["total"].intValue
                        let available = libraryJson["available"].intValue
                        let library = Library(id: id, key: key, total: total, available: available)
                        libraries.append(library)
                    }
                    success(summary: summary, libraries: libraries)
                case .Failure(let error):
                    failure(error: error)
                }
            })
    }
    
    @available(*, deprecated=1) public class func requestLibrarySeatSummary(id: Int, success: (library: Library, readingRooms: [ReadingRoom]) -> Void, failure: FailureHandler) {
        Alamofire.request(.GET, kuStudyAPI.Library(id: id).url)
        .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    let content = json["content"]
                    // Library
                    let id = content["id"].intValue
                    let key = content["key"].stringValue
                    let total = content["total"].intValue
                    let available = content["available"].intValue
                    let library = Library(id: id, key: key, total: total, available: available)
                    // Reading Room
                    let readingRoomsJson = content["rooms"].arrayValue
                    var readingRooms = [ReadingRoom]()
                    for readingRoomJson in readingRoomsJson {
                        let id = readingRoomJson["id"].intValue
                        let key = readingRoomJson["key"].stringValue
                        let total = readingRoomJson["total"].intValue
                        let available = readingRoomJson["available"].intValue
                        let readingRoom = ReadingRoom(id: id, key: key, total: total, available: available)
                        readingRooms.append(readingRoom)
                    }
                    success(library: library, readingRooms: readingRooms)
                case .Failure(let error):
                    failure(error: error)
                }
            })
    }
    
    @available(*, deprecated=1) public class func requestReadingRoomSeatSummary(id: Int, success: (readingRoom: ReadingRoom) -> Void, failure: FailureHandler) {
        Alamofire.request(.GET, kuStudyAPI.ReadingRoom(id: id).url)
        .authenticate(user: kuStudyAPIAccessId, password: kuStudyAPIAccessPassword)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    let content = json["content"]
                    // Reading room
                    let id = content["id"].intValue
                    let key = content["key"].stringValue
                    let total = content["total"].intValue
                    let available = content["available"].intValue
                    let readingRoom = ReadingRoom(id: id, key: key, total: total, available: available)
                    success(readingRoom: readingRoom)
                case .Failure(let error):
                    failure(error: error)
                }
            })
    }
}
