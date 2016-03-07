//
//  PecentageColorPresentable.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 7..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public protocol PercentageColorPresentable {
    var usedPercentageColor: UIColor { get }
}

public extension PercentageColorPresentable where Self: Seatable {
    public var usedPercentageColor: UIColor {
        switch usedPercentage {
        case let p where p > 0.9: return kuStudyColorError
        case let p where p > 0.75: return kuStudyColorWarning
        case let p where p > 0.6: return kuStudyColorLightWarning
        default: return kuStudyColorConfirm
        }
    }
}
