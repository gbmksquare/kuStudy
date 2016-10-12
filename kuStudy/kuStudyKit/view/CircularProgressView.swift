//
//  CircularProgressView.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 22..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

// @IBDesignable // UIStoryboard can't render IBDesignable in dynamic framework bug
public class CircularProgressView: UIView {
    fileprivate var arcLayer: CAShapeLayer!
    fileprivate var backgroundLayer: CAShapeLayer!
    
    @IBInspectable public var progressColor = UIColor.orange {
        didSet { updateLayerProperties() }
    }
    
    @IBInspectable public var progress: Float = 0.0 {
        didSet { updateLayerProperties() }
    }
    
    @IBInspectable public var progressInset: CGFloat = 3.0 {
        didSet { updateLayerProperties() }
    }
    
    @IBInspectable public var progressBackgroundColor = UIColor.white {
        didSet { updateLayerProperties() }
    }
    
    // MARK: Initialization
    override public func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        createViewIfNeccessary()
    }
    
    // MARK: View
    override public func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = layer.bounds
        arcLayer.frame = layer.bounds
        updateLayerProperties()
    }
    
    fileprivate func createViewIfNeccessary() {
        if backgroundLayer == nil {
            backgroundLayer = CAShapeLayer()
            layer.addSublayer(backgroundLayer)
            
            let rect = bounds.insetBy(dx: 0, dy: 0)
            let path = UIBezierPath(ovalIn: rect)
            backgroundLayer.path = path.cgPath
            backgroundLayer.fillColor = progressBackgroundColor.cgColor
        }
        
        if arcLayer == nil {
            arcLayer = CAShapeLayer()
            layer.addSublayer(arcLayer)
            
            let arcPath = createArc()
            arcLayer.path = arcPath.cgPath
            arcLayer.fillColor = progressColor.cgColor
        }
    }
    
    fileprivate func updateLayerProperties() {
        createViewIfNeccessary()
        let rect = bounds.insetBy(dx: 0, dy: 0)
        let path = UIBezierPath(ovalIn: rect)
        backgroundLayer.path = path.cgPath
        backgroundLayer.fillColor = progressBackgroundColor.cgColor
        arcLayer.fillColor = progressColor.cgColor
        repositionArcLayer()
    }
    
    // Helper
    fileprivate func createArc() -> UIBezierPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = bounds.width / 2 - progressInset
        let startAngle = CGFloat(M_PI + M_PI_2)
        let endAngle = startAngle + CGFloat(M_PI) * 2 * CGFloat(progress)
        let arcPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arcPath.addLine(to: center)
        return arcPath
    }
    
    fileprivate func repositionArcLayer() {
        let arcPath = createArc()
        arcLayer.path = arcPath.cgPath
    }
}
