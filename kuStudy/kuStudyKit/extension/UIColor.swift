//
//  UIColor.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 10..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

public extension UIColor {
    static var error: UIColor {
        let color = UIColor(hue:0.01, saturation:0.74, brightness:0.94, alpha:1)
        if #available(iOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *) {
            return UIColor(named: "Error") ?? color
        }
        return color
    }
    
    static var warning: UIColor {
        let color = UIColor(hue:0.09, saturation:0.82, brightness:0.99, alpha:1)
        if #available(iOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *) {
            return UIColor(named: "Warning") ?? color
        }
        return color
    }
    
    static var warningLight: UIColor {
        let color = UIColor(hue:0.12, saturation:0.79, brightness:0.99, alpha:1)
        if #available(iOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *) {
            return UIColor(named: "Warning Light") ?? color
        }
        return color
    }
    
    static var confirm: UIColor {
        let color = UIColor(hue:0.34, saturation:0.52, brightness:0.68, alpha:1)
        if #available(iOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *) {
            return UIColor(named: "Confirm") ?? color
        }
        return color
    }
}
