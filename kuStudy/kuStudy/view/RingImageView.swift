//
//  RingImageView.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 4..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

@IBDesignable
class RingImageView: UIView {
    private var ringLayer: CAShapeLayer!
    private var backgroundRingLayer: CAShapeLayer!
    @IBInspectable var ringColor = UIColor.lightGrayColor()
    
    var image: UIImage?
    private var imageLayer: CALayer!
    
    @IBInspectable var rating: Float = 0.0 {
        didSet { updateLayerProperties() }
    }
    
    @IBInspectable var lineWidth: CGFloat = 5.0 {
        didSet { updateLayerProperties() }
    }
    
    // MARK: Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
    }
    
    // MARK: View
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if backgroundRingLayer == nil {
            backgroundRingLayer = CAShapeLayer()
            layer.addSublayer(backgroundRingLayer)
            
            let rect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
            let path = UIBezierPath(ovalInRect: rect)
            
            backgroundRingLayer.path = path.CGPath
            backgroundRingLayer.fillColor = nil
            backgroundRingLayer.lineWidth = lineWidth
            backgroundRingLayer.strokeColor = UIColor(white: 0.5, alpha: 0.3).CGColor
        }
        backgroundRingLayer.frame = layer.bounds
        
        if ringLayer == nil {
            ringLayer = CAShapeLayer()
            
            let innerRect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
            let innerPath = UIBezierPath(ovalInRect: innerRect)
            
            ringLayer.path = innerPath.CGPath
            ringLayer.fillColor = nil
            ringLayer.lineWidth = lineWidth
            ringLayer.strokeEnd = 0.0
            ringLayer.strokeColor = UIColor.darkGrayColor().CGColor
            ringLayer.lineCap = kCALineCapRound
            ringLayer.anchorPoint = CGPointMake(0.5, 0.5)
            ringLayer.transform = CATransform3DRotate(ringLayer.transform, -CGFloat(M_PI)/CGFloat(2), 0, 0, 1)
            
            layer.addSublayer(ringLayer)
        }
        ringLayer.frame = layer.bounds
        
        if imageLayer == nil {
            let imageMaskLayer = CAShapeLayer()
            
            let insetBounds = CGRectInset(bounds, lineWidth + 1.0, lineWidth + 1.0)
            let innerPath = UIBezierPath(ovalInRect: insetBounds)
            
            imageMaskLayer.path = innerPath.CGPath
            imageMaskLayer.fillColor = UIColor.blackColor().CGColor
            imageMaskLayer.frame = bounds
            layer.addSublayer(imageMaskLayer)
            
            imageLayer = CALayer()
            imageLayer.mask = imageMaskLayer
            imageLayer.frame = bounds
            imageLayer.backgroundColor = UIColor.lightGrayColor().CGColor
            imageLayer.contentsGravity = kCAGravityResizeAspectFill
            layer.addSublayer(imageLayer)
        }
        
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        ringLayer?.strokeEnd = CGFloat(rating)
        ringLayer?.strokeColor = ringColor.CGColor
        
        if let image = image {
            imageLayer?.contents = image.CGImage
        }
    }
}
