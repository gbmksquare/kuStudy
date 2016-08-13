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
    
    let photographers: [Photographer]
    let photoLocations: [PhotoLocation]
    let photos: [Photo]
    
    /// [Library ID: Photo Index]
    private var loadedPhotos = [Int: Int]()
    
    // MARK: Initialization
    init() {
        // Photographers
        let photographersUrl = NSBundle(forClass: kuStudy.self).URLForResource("Photographers", withExtension: "plist")!
        let photographersContent = NSArray(contentsOfURL: photographersUrl)!
        
        photographers = photographersContent.map { (item) -> Photographer in
            let id = item["id"] as! Int
            let name = item["name"] as! String
            let name_en = item["name_en"] as! String
            let association = item["association"] as! String
            let association_en = item["association_en"] as! String
            return Photographer(id: id, name: name, name_en: name_en, association: association, association_en: association_en)
        }
        
        // Photo locations
        let photoLocationsUrl = NSBundle(forClass: kuStudy.self).URLForResource("PhotoLocations", withExtension: "plist")!
        let photoLocationsContent = NSArray(contentsOfURL: photoLocationsUrl)!
        
        photoLocations = photoLocationsContent.map({ (item) -> PhotoLocation in
            let key = item["key"] as! String
            let id = item["id"] as! Int
            return PhotoLocation(id: id, key: key)
        })
        
        // Photos
        let photosUrl = NSBundle(forClass: kuStudy.self).URLForResource("Photos", withExtension: "plist")!
        let photosContent = NSArray(contentsOfURL: photosUrl)!
        
        photos = photosContent.map({ (item) -> Photo in
            let imageName = item["name"] as! String
            let locationId = item["libraryId"] as! Int
            let photographerId = item["photographerId"] as! Int
            let description = item["description"] as! String
            return Photo(imageName: imageName, locationId: locationId, photographerId: photographerId, description: description)
        })
    }
    
    // MARK: Photo
    public func photo(libraryId: String) -> Photo {
        return photo(Int(libraryId)!)
    }
    
    public func photo(libraryId: Int) -> Photo {
        let photos = self.photos.filter({ $0.locationId == libraryId })
        
        // Get new index if needed
        if loadedPhotos[libraryId] == nil {
            let randomIndex = Int(arc4random_uniform(UInt32(photos.count)))
            loadedPhotos[libraryId] = randomIndex
        }
        
        let index = loadedPhotos[libraryId]!
        return photos[index]
    }
}
