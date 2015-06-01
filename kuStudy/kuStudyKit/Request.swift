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
    public func requestInfo(handler: CompletionHandler) {
        Alamofire.request(.GET, kuStudyAPI.Info.url)
        .authenticate(user: authId, password: authPassword)
        .responseJSON(options: .AllowFragments) { (_, _, responseObject, error) -> Void in
            self.handleResponseObject(responseObject, error: error, handler: handler)
        }
    }
    
    public func requestSummary(handler: CompletionHandler) {
        Alamofire.request(.GET, kuStudyAPI.Summary.url)
        .authenticate(user: authId, password: authPassword)
        .responseJSON(options: .AllowFragments) { (_, _, responseObject, error) -> Void in
            self.handleResponseObject(responseObject, error: error, handler: handler)
        }
    }
    
    public func requestLibrary(id: Int, handler: CompletionHandler) {
        Alamofire.request(.GET, kuStudyAPI.Library(id: id).url)
        .authenticate(user: authId, password: authPassword)
        .responseJSON(options: .AllowFragments) { (_, _, responseObject, error) -> Void in
            self.handleResponseObject(responseObject, error: error, handler: handler)
        }
    }
    
    public func requestReadingRoom(id: Int, handler: CompletionHandler) {
        Alamofire.request(.GET, kuStudyAPI.ReadingRoom(id: id).url)
        .authenticate(user: authId, password: authPassword)
        .responseJSON(options: .AllowFragments) { (_, _, responseObject, error) -> Void in
            self.handleResponseObject(responseObject, error: error, handler: handler)
        }
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
