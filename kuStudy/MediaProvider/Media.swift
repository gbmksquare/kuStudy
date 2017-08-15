//
//  Media.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 8. 13..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import kuStudyKit

public struct Media {
    public enum MediaType {
        case photo, timelapse, illustration, movie
    }
    
    public enum Category {
        case main, library
    }
    
    public enum Weather {
        case sun, cloud, rain, snow
    }
    
    public enum Timespan {
        case sunrise, day, sunset, night
    }
    
    let mediaType: MediaType
    let library: LibraryType
    let creator: Creator
    let category: Category
    let timespan: Timespan
    let weather: Weather
    
    let resourceName: String
    let thumbnailResourceName: String
}
