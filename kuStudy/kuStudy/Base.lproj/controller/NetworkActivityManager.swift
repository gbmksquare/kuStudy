//
//  NetworkActivityManager.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 1. 25..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation
import UIKit

class NetworkActivityManager {
    static let sharedManager = NetworkActivityManager()
    
    private var activityCount = 0 {
        willSet {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = newValue > 0 ? true : false
        }
    }
    
    class func increaseActivityCount() {
        NetworkActivityManager.sharedManager.activityCount += 1
    }
    
    class func decreaseActivityCount() {
        NetworkActivityManager.sharedManager.activityCount -= 1
    }
}
