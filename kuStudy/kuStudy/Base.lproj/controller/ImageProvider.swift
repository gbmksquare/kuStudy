//
//  ImageProvider.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 5..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

// MARK: Model
struct Photographer {
    let id: Int
    let name: String
    let association: String
}

private struct Photo {
    let name: String
    let photographerId: Int
    let description: String
}

private struct Library {
    let key: String
    let id: Int
    let photos: [Photo]
}

// MARK: Image provider
// TODO: Change to protocol oriented
class ImageProvider {
    static let sharedProvider = ImageProvider()
    
    private var libraries: [Library]!
    private var photographers: [Photographer]!
    
    private var loadedPhotos = [Int: Photo]()
    
    // MARK: Initialization
    init() {
        loadPhotographers()
        loadPhotos()
    }
    
    private func loadPhotographers() {
        guard let path = NSBundle.mainBundle().pathForResource("Photographers", ofType: "plist"),
            photographerInfos = NSArray(contentsOfFile: path) else {
                return
        }
        
        var photographers = [Photographer]()
        for photographerInfo in photographerInfos {
            guard let id = photographerInfo["id"] as? Int,
                name = photographerInfo["name"] as? String,
                association = photographerInfo["association"] as? String else {
                    continue
            }
            
            let photographer = Photographer(id: id, name: name, association: association)
            photographers.append(photographer)
        }
        self.photographers = photographers
    }
    
    private func loadPhotos() {
        guard let path = NSBundle.mainBundle().pathForResource("Photos", ofType: "plist"),
            libraryInfos = NSArray(contentsOfFile: path) else {
                return
        }
        
        var libraries = [Library]()
        for libraryInfo in libraryInfos {
            guard let key = libraryInfo["libraryKey"] as? String,
                id = libraryInfo["libraryId"] as? Int,
                photoInfos = libraryInfo["photos"] as? [NSDictionary] else {
                    continue
            }
            
            var photos = [Photo]()
            for photoInfo in photoInfos {
                guard let name = photoInfo["name"] as? String,
                    id = photoInfo["photographerId"] as? Int,
                    description = photoInfo["description"] as? String else {
                        continue
                }
                
                let photo = Photo(name: name, photographerId: id, description: description)
                photos.append(photo)
            }
            
            let library = Library(key: key, id: id, photos: photos)
            libraries.append(library)
        }
        self.libraries = libraries
    }
    
    // MARK: Image
    private func photographerForId(id: Int) -> Photographer? {
        for photographer in photographers {
            if photographer.id == id {
                return photographer
            }
        }
        return nil
    }
    
    private func libraryForId(id: Int) -> Library? {
        for library in libraries {
            if library.id == id {
                return library
            }
        }
        return nil
    }
    
    func imageForLibrary(libraryId: Int) -> (image: UIImage, photographer: Photographer)? {
        // Loaded image
        if let loadedPhoto = loadedPhotos[libraryId] {
            guard let photographer = photographerForId(loadedPhoto.photographerId),
                image = UIImage(named: loadedPhoto.name) else {
                    return nil
            }
            return (image, photographer)
        }
        
        // New image
        guard let library = libraryForId(libraryId) else {
            return nil
        }
        
        let photosCount = library.photos.count
        guard photosCount > 0 else {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(photosCount - 1)))
        let photo = library.photos[randomIndex]
        loadedPhotos[libraryId] = photo
        
        guard let photographer = photographerForId(photo.photographerId),
            image = UIImage(named: photo.name) else {
                return nil
        }
        return (image, photographer)
    }
}
