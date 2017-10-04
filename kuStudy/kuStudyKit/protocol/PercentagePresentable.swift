//
//  PercentagePresentable.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 10..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

public protocol PercentagePresentable {
    var availablePercentage: Float { get }
    var availablePercentageColor: UIColor { get }
    
    var occupiedPercentage: Float { get }
    var occupiedPercentageColor: UIColor { get }
}

public extension PercentagePresentable {
    var availablePercentageColor: UIColor {
        switch availablePercentage {
        case let p where p < 0.1: return UIColor.error
        case let p where p < 0.25: return UIColor.warning
        case let p where p < 0.4: return UIColor.warningLight
        default: return UIColor.confirm
        }
    }
    
    var occupiedPercentageColor: UIColor {
        switch occupiedPercentage {
        case let p where p > 0.9: return UIColor.error
        case let p where p > 0.75: return UIColor.warning
        case let p where p > 0.6: return UIColor.warningLight
        default: return UIColor.confirm
        }
    }
}
