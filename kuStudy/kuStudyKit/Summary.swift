//
//  Summary.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 4..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation

public struct Summary: Seatable, DatePresentable, ImagePresentable {
    public var total = 0
    public var available = 0
    public var updatedTime = NSDate()
    
    public var photo: (image: UIImage, photographer: Photographer)? {
        let imageProvider = ImageProvider.sharedProvider
        return imageProvider.imageForLibrary(2)
    }
    
    init(total: Int, available:Int, time: String) {
        self.total = total
        self.available = available
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        updatedTime = formatter.dateFromString(time) ?? NSDate()
    }
}
