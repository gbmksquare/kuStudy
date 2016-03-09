//
//  ImagePresentable.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 9..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

public protocol ImagePresentable {
    var photo: (image: UIImage, photographer: Photographer)? { get }
}

public extension ImagePresentable where Self: Identifiable {
    public var photo: (image: UIImage, photographer: Photographer)? {
        let imageProvider = ImageProvider.sharedProvider
        return imageProvider.imageForLibrary(id)
    }
}