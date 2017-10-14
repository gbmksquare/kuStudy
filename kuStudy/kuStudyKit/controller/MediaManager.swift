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
    internal let artists: [Artist]
    
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
    public func media(for library: LibraryType,
                      artist: Artist? = nil,
                      mediaType: Media.MediaType? = nil,
                      presentationType: Media.PresentationType? = nil,
                      timeframe: Media.Timeframe? = nil,
                      weather: Media.Weather? = nil) -> [Media] {
        return media
            .filter({ $0.library == library })
            .filter({ $0.artist == artist })
            .filter({ $0.mediaType == mediaType })
            .filter({ $0.presentationType == presentationType })
            .filter({ $0.timeframe == timeframe })
            .filter({ $0.weather == weather })
    }
    
    public func media(by artist: Artist,
                      library: LibraryType? = nil,
                      mediaType: Media.MediaType,
                      presentationType: Media.PresentationType? = nil,
                      timeframe: Media.Timeframe? = nil,
                      weather: Media.Weather? = nil) -> [Media] {
        return media
            .filter({ $0.artist == artist })
            .filter({ $0.library == library })
            .filter({ $0.mediaType == mediaType })
            .filter({ $0.presentationType == presentationType })
            .filter({ $0.timeframe == timeframe })
            .filter({ $0.weather == weather })
    }
    
    // TODO: Cached media for summary and library
    
    // TODO: Preset media for Snapshot screenshot
}
