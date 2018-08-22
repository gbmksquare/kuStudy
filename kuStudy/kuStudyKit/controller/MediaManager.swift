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
    
    // MARK: - Suggest Media
    func preferredMediaForMain() -> Media? {
        clearCacheIfNecessary()
        
        if let identifier = cachedMedia["main"], let cached = media(with: identifier) {
            return cached
        } else {
            let collection = MediaManager.media.filter({ $0.presentationType == .main })
            let media = collection[randomIndex(below: collection.count)]
            cachedMedia["main"] = media.identifier
            return media
        }
    }
    
    func preferredMedia(for library: LibraryType) -> Media {
        // Snapshot
        let isRunningSnapshot = ProcessInfo.processInfo.arguments.contains("Snapshot") ? true : false
        if isRunningSnapshot == true {
            return predefinedMedia(for: library)
        }
        
        clearCacheIfNecessary()
        let suitable = suitableMedia(for: library)
        
        // Cached
        if let identifier = cachedMedia[library.rawValue], let cached = media(with: identifier) {
            return cached
        }
        
        let index = randomIndex(below: suitable.count)
        let randomMedia = suitable[index]
        cachedMedia[library.rawValue] = randomMedia.identifier
        return randomMedia
    }
    
    func suitableMedia(for library: LibraryType) -> [Media] {
        let suitableTimeframe = Media.Timeframe.suitableTimeframeForNow()
        let suitableResults = media(for: library,
                           artist: nil,
                           mediaType: nil,
                           presentationType: nil,
                           timeframe: suitableTimeframe,
                           weather: nil)
        if suitableResults.count > 0 {
            return suitableResults
        }
        
        // Fallback
        let fallbackTimeframe = Media.Timeframe.fallbackTimeFrameForNow()
        let fallbackResults = media(for: library,
                           artist: nil,
                           mediaType: nil,
                           presentationType: nil,
                           timeframe: fallbackTimeframe,
                           weather: nil)
        assert(fallbackResults.count != 0)
        return fallbackResults
    }
    
    // MARK: - Fetch media
    func media(with identifier: String) -> Media? {
        return MediaManager.media.first(where: { $0.identifier == identifier })
    }
    
    func predefinedMedia(for library: LibraryType) -> Media {
        switch library {
        case .centralLibrary: return media(with: "B462E6C0-047A-4E48-A316-3DF99CEAB467")!
        case .centralSquare: return media(with: "6B4F4F14-44BC-420D-88A3-C0BC421EC59A")!
        case .cdl: return media(with: "EE91695A-EFD7-44CD-BEFC-41FE0399DFBB")!
        case .hanaSquare: return media(with: "B9BFA3F5-50B7-4D7F-A202-4604158E222C")!
        case .scienceLibrary: return media(with: "6BCD6F93-1F25-40F1-BA72-56CAF764A52A")!
        case .law: return media(with: "874C3FF8-B077-4D9D-ABAE-12E81DA9CA32")!
        }
    }
    
    func media(for library: LibraryType,
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
    
    func media(by artist: Artist,
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
    
    // MARK: - Cache
    func clearCache() {
        cachedMedia = [:]
        self.cachedAt = Date()
    }
    
    func clearCacheIfNecessary() {
        if let cachedAt = cachedAt {
            let interval = Date().timeIntervalSince(cachedAt)
            if interval >= cacheClearInterval {
                clearCache()
                
                // Notify
                NotificationCenter.default.post(name: MediaManager.shouldUpdateImageNotification, object: self)
            }
        } else {
            cachedAt = Date()
        }
    }
    
    // MARK: - Helper
    private func randomIndex(below max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
}

// MARK: - Notification
extension MediaManager {
    public static let shouldUpdateImageNotification = Notification.Name(rawValue: "kuStudyKit.MediaManager.Notification.ShouldUpdateImage")
}
