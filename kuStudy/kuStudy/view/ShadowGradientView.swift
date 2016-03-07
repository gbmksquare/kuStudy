//
//  ShadowGradientView.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 5..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

class ShadowGradientView: UIView {
    private var shadowGradient: CAGradientLayer?
    
    // MARK: Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    // MARK: Setup
    private func initialSetup() {
        backgroundColor = UIColor.clearColor()
        
        // Gradient
        let shadowGradient = CAGradientLayer()
        shadowGradient.colors = [
            UIColor(white: 0, alpha: 0).CGColor,
            UIColor(white: 0, alpha: 0.45).CGColor,
//            UIColor(white: 0, alpha: 0.55).CGColor,
            UIColor(white: 0, alpha: 0.75).CGColor]
        shadowGradient.locations = [
            NSNumber(float: 0.0),
            NSNumber(float: 0.3),
//            NSNumber(float: 0.5),
            NSNumber(float: 1.0)]
        shadowGradient.startPoint = CGPoint(x: 0, y: 0)
        shadowGradient.endPoint = CGPoint(x: 0, y: 1)
        layer.addSublayer(shadowGradient)
        
        self.shadowGradient = shadowGradient
        refreshGradientLayout()
    }
    
    func refreshGradientLayout() {
        shadowGradient?.frame = bounds
    }
    
    // MARK: Layer
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
}
