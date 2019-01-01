//
//  AppIcon.swift
//  kuStudy
//
//  Created by BumMo Koo on 02/01/2019.
//  Copyright © 2019 gbmKSquare. All rights reserved.
//

import UIKit

struct AppIcon {
    let imageName: String
    let name: String
    let description: String?
    
    var image: UIImage? {
        return UIImage(named: "\(imageName)60x60")
    }
}
