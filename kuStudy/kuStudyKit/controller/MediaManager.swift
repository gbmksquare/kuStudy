//
//  MediaManager.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 14..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import kuStudyKit

class MediaManager {
    public static let shared = MediaManager()
    
    private var cachedMedia = [String: String]()
    private var cachedAt: Date?
    private let cacheClearInterval: TimeInterval = 180
    
    // MARK: - Initialization
    init() {
        
    }
    
    // MARK: - Media
    // Multiple media with filtering
    public func media(for library: LibraryType,
                      artist: Artist? = nil,
                      mediaType: Media.MediaType? = nil,
                      presentationType: Media.PresentationType? = nil,
                      timeframe: Media.Timeframe? = nil,
                      weather: Media.Weather? = nil) -> [Media] {
        return MediaManager.media
            .filter({ $0.library == library })
            .filter({ return artist == nil ? true : $0.artist == artist })
            .filter({ return mediaType == nil ? true : $0.mediaType == mediaType })
            .filter({ return presentationType == nil ? true : $0.presentationType == presentationType })
            .filter({ return timeframe == nil ? true : $0.timeframe == timeframe })
            .filter({ return weather == nil ? true : $0.weather == weather })
    }
    
    public func media(by artist: Artist,
                      library: LibraryType? = nil,
                      mediaType: Media.MediaType? = nil,
                      presentationType: Media.PresentationType? = nil,
                      timeframe: Media.Timeframe? = nil,
                      weather: Media.Weather? = nil) -> [Media] {
        return MediaManager.media
            .filter({ $0.artist == artist })
            .filter({ return library == nil ? true : $0.library == library })
            .filter({ return mediaType == nil ? true : $0.mediaType == mediaType })
            .filter({ return presentationType == nil ? true : $0.presentationType == presentationType })
            .filter({ return timeframe == nil ? true : $0.timeframe == timeframe })
            .filter({ return weather == nil ? true : $0.weather == weather })
    }
    
    // Defined media with cache and auto update
    public func mediaForMain() -> Media? {
        clearCacheIfNecessary()
        
        if let identifier = cachedMedia["main"] {
            return media(with: identifier)
        } else {
            let collection = MediaManager.media.filter({ $0.presentationType == Media.PresentationType.main })
            let media = collection[randomIndex(below: collection.count)]
            cachedMedia["main"] = media.identifier
            return media
        }
    }
    
    public func media(for library: LibraryType) -> Media? {
        // Snapshot
        let isRunningSnapshot = ProcessInfo.processInfo.arguments.contains("Snapshot") ? true : false
        if isRunningSnapshot == true {
            switch library {
            case .centralLibrary: return media(with: "B462E6C0-047A-4E48-A316-3DF99CEAB467")
            case .centralSquare: return media(with: "6B4F4F14-44BC-420D-88A3-C0BC421EC59A")
            case .cdl: return media(with: "EE91695A-EFD7-44CD-BEFC-41FE0399DFBB")
            case .hanaSquare: return media(with: "B9BFA3F5-50B7-4D7F-A202-4604158E222C")
            case .scienceLibrary: return media(with: "6BCD6F93-1F25-40F1-BA72-56CAF764A52A")
            case .law: return media(with: "874C3FF8-B077-4D9D-ABAE-12E81DA9CA32")
            }
        }
        
        // Provide media
        clearCacheIfNecessary()
        
        if let identifier = cachedMedia[library.rawValue] {
            return media(with: identifier)
        } else {
            let collection = self.media(for: library, artist: nil, mediaType: nil, presentationType: nil, timeframe: nil, weather: nil)
            let media = collection[randomIndex(below: collection.count)]
            cachedMedia[library.rawValue] = media.identifier
            return media
        }
    }
    
    private func media(with identifier: String) -> Media? {
        return MediaManager.media.filter({ $0.identifier == identifier }).first
    }
    
    // MARK: - Helper
    private func randomIndex(below max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
    
    private func clearCacheIfNecessary() {
        if let cachedAt = cachedAt {
            let interval = Date().timeIntervalSince(cachedAt)
            if interval >= cacheClearInterval {
                cachedMedia = [:]
                self.cachedAt = Date()
                
                // Notify
                NotificationCenter.default.post(name: MediaManager.shouldUpdateImageNotification, object: self)
            }
        } else {
            cachedAt = Date()
        }
    }
}

// MARK: - Notification
extension MediaManager {
    public static let shouldUpdateImageNotification = Notification.Name(rawValue: "kuStudyKit.MediaManager.Notification.ShouldUpdateImage")
}
