//
//  ImageProvider.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 5..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

public class PhotoProvider {
    public static let sharedProvider = PhotoProvider()
    
    public let photographers: [Photographer]
    let photoLocations: [PhotoLocation]
    public let photos: [Photo]
    
    /// [Library ID: Photo Index]
    private var loadedPhotos = [Int: Int]()
    
    // MARK: Initialization
    init() {
        // Photographers
        let photographersUrl = Bundle(for: kuStudy.self).url(forResource: "Photographers", withExtension: "plist")!
        let photographersContent = NSArray(contentsOf: photographersUrl)!
        
        photographers = photographersContent.map { (item) -> Photographer in
            let item = item as! [String: Any]
            let id = item["id"] as! Int
            let name = item["name"] as! String
            let name_en = item["name_en"] as! String
            let association = item["association"] as! String
            let association_en = item["association_en"] as! String
            let instagramId = item["instagram"] as! String
            return Photographer(id: id, name: name, name_en: name_en, association: association, association_en: association_en, instagramId: instagramId)
        }
        
        // Photo locations
        let photoLocationsUrl = Bundle(for: kuStudy.self).url(forResource: "PhotoLocations", withExtension: "plist")!
        let photoLocationsContent = NSArray(contentsOf: photoLocationsUrl)!
        
        photoLocations = photoLocationsContent.map({ (item) -> PhotoLocation in
            let item = item as! [String: Any]
            let key = item["key"] as! String
            let id = item["id"] as! Int
            // Convert old id
            let newId = Int(LibraryType.convertToNewLibraryIdFromOld(id: "\(id)"))!
            return PhotoLocation(id: newId, key: key)
        })
        
        // Photos
        let photosUrl = Bundle(for: kuStudy.self).url(forResource: "Photos", withExtension: "plist")!
        let photosContent = NSArray(contentsOf: photosUrl)!
        
        photos = photosContent.map({ (item) -> Photo in
            let item = item as! [String: Any]
            let imageName = item["name"] as! String
            let locationId = item["libraryId"] as! Int
            let photographerId = item["photographerId"] as! Int
            let description = item["description"] as! String
            // Convert old id
            let newLocationId = Int(LibraryType.convertToNewLibraryIdFromOld(id: "\(locationId)"))!
            return Photo(imageName: imageName, locationId: newLocationId, photographerId: photographerId, description: description)
        })
    }
    
    // MARK: Photo
    public func photo(_ libraryId: String) -> Photo {
        return photo(Int(libraryId)!)
    }
    
    public func photo(_ libraryId: Int) -> Photo {
        let photos = self.photos.filter({ $0.locationId == libraryId })
        
        // Get new index if needed
        if loadedPhotos[libraryId] == nil {
            let isRunningTest = ProcessInfo.processInfo.arguments.contains("Snapshot") ? true : false
            if isRunningTest == true {
                let index = predefinedIndex(libraryId: libraryId)
                loadedPhotos[libraryId] = index
            } else {
                let randomIndex = Int(arc4random_uniform(UInt32(photos.count)))
                loadedPhotos[libraryId] = randomIndex
            }
        }
        
        let index = loadedPhotos[libraryId]!
        return photos[index]
    }
    
    // Fastlane Snapshot
    private func predefinedIndex(libraryId: Int) -> Int {
        guard let libraryType = LibraryType(rawValue: "\(libraryId)") else {
            return 0
        }
        switch libraryType {
        case .CentralSquare: return 0
        case .CentralLibrary: return 2
        case .CDL: return 0
        case .HanaSquare: return 0
        case .ScienceLibrary: return 5
        }
    }
}
