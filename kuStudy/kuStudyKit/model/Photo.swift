//
//  Photo.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 10..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

struct Photo {
    let imageName: String
    let locationId: Int
    let photographerId: Int
    let description: String
    
    var thumbnailName: String {
        return imageName + "_thumbnail"
    }
    
    var photographer: Photographer {
        return PhotoProvider.sharedProvider.photographers.filter({ $0.id == photographerId }).first!
    }
    
    var photoLocation: PhotoLocation {
        return PhotoProvider.sharedProvider.photoLocations.filter({ $0.id == locationId }).first!
    }
}

extension Photo {
    var thumbnail: UIImage? {
        #if os(watchOS)
            return nil
        #else
            return UIImage(named: thumbnailName, inBundle: NSBundle(forClass: kuStudy.self), compatibleWithTraitCollection: nil)
        #endif
    }
    
    var image: UIImage? {
        #if os(watchOS)
            return nil
        #else
            return UIImage(named: imageName, inBundle: NSBundle(forClass: kuStudy.self), compatibleWithTraitCollection: nil)
        #endif
    }
}
