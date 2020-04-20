//
//  UIColor.swift
//  kuStudy
//
//  Created by BumMo Koo on 04/01/2020.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

extension UIColor {
    static let appPrimary = UIColor(named: "App Primary")!
    static let appAprilFoolsPrimary = UIColor(named: "App April Fools Primary")!
    
    static let success = UIColor(named: "Success")!
    static let warning = UIColor(named: "Warning")!
    static let error = UIColor(named: "Error")!
    static let fatal = UIColor(named: "Fatal")!
    
    static var spacious: UIColor { return .success }
    static var average: UIColor { return .warning }
    static var crowded: UIColor { return .error }
    static var full: UIColor { return .fatal }
}
