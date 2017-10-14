//
//  MediaManager.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 14..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation

public class MediaManager {
    public static let shared = MediaManager()
    
    internal let media: [Media]
    public let artists: [Artist]
    
    private var cachedMedia = [String: String]()
    
    // MARK: - Initialization
    init() {
        guard let mediaPresetData = mediaPreset.data(using: .utf8),
            let media = try? JSONDecoder().decode(Array<Media>.self, from: mediaPresetData) else {
                self.media = []
                self.artists = []
                return
        }
        guard let artistsPresetData = artistsPreset.data(using: .utf8),
            let artists = try? JSONDecoder().decode(Array<Artist>.self, from: artistsPresetData) else {
                self.media = []
                self.artists = []
                return
        }
        self.media = media
        self.artists = artists
    }
    
    // MARK: - Media
    // Multiple media with filtering
    public func media(for library: LibraryType,
                      artist: Artist? = nil,
                      mediaType: Media.MediaType? = nil,
                      presentationType: Media.PresentationType? = nil,
                      timeframe: Media.Timeframe? = nil,
                      weather: Media.Weather? = nil) -> [Media] {
        return media
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
        return media
            .filter({ $0.artist == artist })
            .filter({ return library == nil ? true : $0.library == library })
            .filter({ return mediaType == nil ? true : $0.mediaType == mediaType })
            .filter({ return presentationType == nil ? true : $0.presentationType == presentationType })
            .filter({ return timeframe == nil ? true : $0.timeframe == timeframe })
            .filter({ return weather == nil ? true : $0.weather == weather })
    }
    
    // Defined media with cache and auto update
    public func mediaForMain() -> Media? {
        if let identifier = cachedMedia["main"] {
            return media.filter({ $0.identifier == identifier }).first
        } else {
            let collection = self.media.filter({ $0.presentationType == Media.PresentationType.main })
            let media = collection[randomIndex(below: collection.count)]
            cachedMedia["main"] = media.identifier
            return media
        }
    }
    
    public func media(for library: LibraryType) -> Media? {
        if let identifier = cachedMedia[library.rawValue] {
            return media.filter({ $0.identifier == identifier }).first
        } else {
            let collection = self.media(for: library, artist: nil, mediaType: nil, presentationType: nil, timeframe: nil, weather: nil)
            let media = collection[randomIndex(below: collection.count)]
            cachedMedia[library.rawValue] = media.identifier
            return media
        }
    }
    
    // TODO: Preset media for Snapshot screenshot
    
    // MARK: - Helper
    private func randomIndex(below max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
}
