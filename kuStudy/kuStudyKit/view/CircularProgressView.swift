//
//  CircularProgressView.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 22..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

@IBDesignable
public class CircularProgressView: UIView {
    private var arcLayer: CAShapeLayer!
    private var backgroundLayer: CAShapeLayer!
    
    @IBInspectable public var progressColor = UIColor.orangeColor() {
        didSet { updateLayerProperties() }
    }
    
    @IBInspectable public var progress: Float = 0.0 {
        didSet { updateLayerProperties() }
    }
    
    @IBInspectable public var progressInset: CGFloat = 3.0 {
        didSet { updateLayerProperties() }
    }
    
    @IBInspectable public var progressBackgroundColor = UIColor.whiteColor() {
        didSet { updateLayerProperties() }
    }
    
    // MARK: Initialization
    override public func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
        createViewIfNeccessary()
    }
    
    // MARK: View
    override public func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = layer.bounds
        arcLayer.frame = layer.bounds
        updateLayerProperties()
    }
    
    private func createViewIfNeccessary() {
        if backgroundLayer == nil {
            backgroundLayer = CAShapeLayer()
            layer.addSublayer(backgroundLayer)
            
            let rect = CGRectInset(bounds, 0, 0)
            let path = UIBezierPath(ovalInRect: rect)
            backgroundLayer.path = path.CGPath
            backgroundLayer.fillColor = progressBackgroundColor.CGColor
        }
        
        if arcLayer == nil {
            arcLayer = CAShapeLayer()
            layer.addSublayer(arcLayer)
            
            let arcPath = createArc()
            arcLayer.path = arcPath.CGPath
            arcLayer.fillColor = progressColor.CGColor
        }
    }
    
    private func updateLayerProperties() {
        createViewIfNeccessary()
        backgroundLayer.fillColor = progressBackgroundColor.CGColor
        arcLayer.fillColor = progressColor.CGColor
        repositionArcLayer()
    }
    
    // Helper
    private func createArc() -> UIBezierPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = bounds.width / 2 - progressInset
        let startAngle = CGFloat(M_PI + M_PI_2)
        let endAngle = startAngle + CGFloat(M_PI) * 2 * CGFloat(progress)
        let arcPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arcPath.addLineToPoint(center)
        return arcPath
    }
    
    private func repositionArcLayer() {
        let arcPath = createArc()
        arcLayer.path = arcPath.CGPath
    }
}
