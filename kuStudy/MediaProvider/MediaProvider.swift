//
//  MediaProvider.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 8. 12..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import kuStudyKit

public class MediaProvider {
    public static let shared = MediaProvider()
    
    private let allMedia: [Media] = [
        
    ]
    
    private let allCreators: [Creator] = [
        
    ]
    
    func media(for library: LibraryType, creator: Creator? = nil, category: Media.Category? = nil, timespan: Media.Timespan? = nil, weather: Media.Weather? = nil) -> [Media] {
        return allMedia
            .filter({ $0.library == library })
            .filter({ $0.creator == creator })
            .filter({ $0.category == category })
            .filter({ $0.timespan == timespan })
            .filter({ $0.weather == weather })
    }
    
    func media(by creator: Creator) -> [Media] {
        return allMedia.filter { $0.creator == creator }
    }
}
