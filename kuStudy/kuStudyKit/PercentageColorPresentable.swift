//
//  PercentageColorPresentable.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/01.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation

public protocol PercentageColorPresentable {
    var color: UIColor { get }
}

// MARK: - Extension
extension Double: PercentageColorPresentable {
    public var color: UIColor {
        switch self {
        case let value where value > 0.9: return .fatal
        case let value where value > 0.75: return .error
        case let value where value > 0.6: return .warning
        default: return .success
        }
    }
}
