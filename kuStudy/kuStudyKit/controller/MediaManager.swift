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
    public func media(for: LibraryType? = nil,
                      artist: Artist? = nil,
                      mediaType: Media.MediaType,
                      presentationType: Media.PresentationType = .unspecified,
                      timeframe: Media.Timeframe = .unspecified,
                      weather: Media.Weather = .unspecified) -> [Media] {
        return []
    }
    
    // TODO: Cached meida for summary and library
    
    // TODO: Preset media for Snapshot screenshot
}
