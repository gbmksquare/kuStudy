//
//  Media.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 14..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation

public struct Media: Codable {
    public enum MediaType: Int, Codable {
        case photo, video, timelapse, livePhoto, illustration
    }
    
    public enum PresentationType: Int, Codable {
        case unspecified, main, library, detail
    }
    
    public enum Timeframe: Int, Codable {
        case unspecified, twilight, sunrise, day, sunset, evening, night
    }
    
    public enum Weather: Int, Codable {
        case unspecified, sunny, cloudy, windy, rainy, snow
    }
    
    internal let identifier: String
    
    public let mediaType: MediaType
    public let presentationType: PresentationType
    public let timeframe: Timeframe
    public let weather: Weather
    
    private let libraryIdentifier: String
    private let artistIdentifier: String
    
    public let resourceName: String
    public let description: String?
}

public extension Media {
    public var library: LibraryType {
        return LibraryType(rawValue: libraryIdentifier)!
    }
    
    public var artist: Artist {
        return MediaManager.shared.artists.filter { $0.identifier == artistIdentifier }.first!
    }
    
    #if os(iOS)
    public var image: UIImage? {
        switch mediaType {
        case .photo: return UIImage(named: resourceName, in: Bundle(for: kuStudy.self), compatibleWith: nil)
        default: return nil
        }
    }
    
    public var thumbnail: UIImage? {
        switch mediaType {
        case .photo:
            let thumbnailName = resourceName + "_thumbnail"
            if let thumbnail = UIImage(named: thumbnailName, in: Bundle(for: kuStudy.self), compatibleWith: nil) {
                return thumbnail
            } else {
                return UIImage(named: resourceName, in: Bundle(for: kuStudy.self), compatibleWith: nil)
            }
        default: return nil
        }
    }
    #endif
}

let mediaPreset = """
[
    {
        "identifier": "25768BB7-7C25-4881-8FC3-9C396A7341F8",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "libraryIdentifier": "1",
        "artistIdentifier": "GBM920C5-54F6-42DD-9069-5ED5307D0DEC",
        "resourceName": "lyj_cdl_3",
        "description": ""
    },
    {
        "identifier": "A37CA57B-0E39-45A6-AF19-3C330B114F6B",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "libraryIdentifier": "2",
        "artistIdentifier": "GBM920C5-54F6-42DD-9069-5ED5307D0DEC",
        "resourceName": "lyj_cdl_3",
        "description": ""
    },
    {
        "identifier": "ED0D6B42-4C29-4266-BA4D-608FED24C8D9",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "libraryIdentifier": "3",
        "artistIdentifier": "GBM920C5-54F6-42DD-9069-5ED5307D0DEC",
        "resourceName": "lyj_cdl_3",
        "description": ""
    },
    {
        "identifier": "04859B61-D618-4293-9F15-B57FC30404A2",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "libraryIdentifier": "4",
        "artistIdentifier": "GBM920C5-54F6-42DD-9069-5ED5307D0DEC",
        "resourceName": "lyj_cdl_3",
        "description": ""
    },
    {
        "identifier": "E2397A0F-E170-4506-9D67-6C18372A5E52",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "libraryIdentifier": "5",
        "artistIdentifier": "GBM920C5-54F6-42DD-9069-5ED5307D0DEC",
        "resourceName": "lyj_cdl_3",
        "description": ""
    },
    {
        "identifier": "815AF247-C4BC-48C2-AC9B-358A21762C5A",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "libraryIdentifier": "6",
        "artistIdentifier": "GBM920C5-54F6-42DD-9069-5ED5307D0DEC",
        "resourceName": "lyj_cdl_3",
        "description": ""
    }
]
"""
