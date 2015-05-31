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
    public func requestSummary(handler: CompletionHandler) {
        // !!!: Do not force unwrap authentification
        Alamofire.request(.GET, kuStudyAPI.Summary.url)
        .authenticate(user: authId!, password: authPassword!)
        .responseJSON(options: .AllowFragments) { (_, _, responseObject, error) -> Void in
            if let responseObject = responseObject as? [String: AnyObject] {
                let json = JSON(responseObject)
                handler(json: json, error: error)
            } else {
                handler(json: nil, error: error)
            }
        }
    }
    
    public func requestLibrary(id: Int, handler: CompletionHandler) {
        // !!!: Do not force unwrap authentification
        Alamofire.request(.GET, kuStudyAPI.Library(id: id).url)
        .authenticate(user: authId!, password: authPassword!)
        .responseJSON(options: .AllowFragments) { (_, _, responseObject, error) -> Void in
            if let responseObject = responseObject as? [String: AnyObject] {
                let json = JSON(responseObject)
                handler(json: json, error: error)
            } else {
                handler(json: nil, error: error)
            }
        }
    }
    
    public func requestReadingRoom(id: Int, handler: CompletionHandler) {
        // !!!: Do not force unwrap authentification
        Alamofire.request(.GET, kuStudyAPI.ReadingRoom(id: id).url)
        .authenticate(user: authId!, password: authPassword!)
        .responseJSON(options: .AllowFragments) { (_, _, responseObject, error) -> Void in
            if let responseObject = responseObject as? [String: AnyObject] {
                let json = JSON(responseObject)
                handler(json: json, error: error)
            } else {
                handler(json: nil, error: error)
            }
        }
    }
}
