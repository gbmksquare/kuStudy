//
//  UIFontMetrics.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/07.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

extension UIFontMetrics {
    static var largeTitle: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .largeTitle)
    }
    
    static var title1: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .title1)
    }
    
    static var title2: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .title2)
    }
    
    static var title3: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .title3)
    }
    
    static var headline: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .headline)
    }
    
    static var subheadline: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .subheadline)
    }
    
    static var body: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .body)
    }
    
    static var callout: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .callout)
    }
    
    static var footnote: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .footnote)
    }
    
    static var caption1: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .caption1)
    }
    
    static var caption2: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .caption2)
    }
}

// MARK: - Extension
extension UIFont {
    func scaled(for metrics: UIFontMetrics) -> UIFont {
        return metrics.scaledFont(for: self)
    }
}

extension Int {
    func scaled(for metrics: UIFontMetrics) -> CGFloat {
        return metrics.scaledValue(for: CGFloat(self))
    }
}

extension Double {
    func scaled(for metrics: UIFontMetrics) -> CGFloat {
        return metrics.scaledValue(for: CGFloat(self))
    }
}

extension CGFloat {
    func scaled(for metrics: UIFontMetrics) -> CGFloat {
        return metrics.scaledValue(for: self)
    }
}
