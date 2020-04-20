//
//  GBMProgressView.swift
//  SeriesOnProgressView
//
//  Created by BumMo Koo on 13/02/2019.
//  Copyright © 2019 gbmksquare. All rights reserved.
//

import UIKit

class GBMProgressView: UIControl {
    enum Style {
        case bar
        case circular
    }
    
    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    
    // MARK: - Property
    var progressViewStyle: GBMProgressView.Style = .bar {
        didSet { updateProgressViewStyle() }
    }
    
    var progressTintColor: UIColor = .link {
        didSet  { updateProgressColor() }
    }
    
    var trackTintColor: UIColor = .quaternarySystemFill {
        didSet { updateTrackColor() }
    }
    
    var lineWidth: CGFloat =  4 {
        didSet { updateLineWidth() }
    }
    
    var lineCapStyle: CAShapeLayerLineCap = .round {
        didSet { updateLineCapStyle() }
    }
    
    var progress: Float = 0 {
        didSet {
            updateProgress()
            sendActions(for: .valueChanged)
        }
    }
    
    // MARK: - Initialization
    init(progressViewStyle: GBMProgressView.Style) {
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - View
    override func layoutSubviews() {
        super.layoutSubviews()
        recreateProgressView()
    }
    
    // MARK: - Setup
    private func setup() {
        recreateProgressView()
    }
    
    
    // MARK: - Create
    private func createBarProgressLayers() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2)
        
//        let start = CGPoint(x: bounds.minX, y: bounds.midY)
//        let end = CGPoint(x: bounds.maxX, y: bounds.midY)
//        let path = UIBezierPath()
//        path.move(to: start)
//        path.addLine(to: end)
        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
//        progressLayer.strokeEnd = 0
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
        updateAllProperties()
    }
    
    private func createCircularProgressLayer() {
        let midPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        let startAngle = CGFloat.pi * -0.5
        let endAngle = CGFloat.pi * 1.5
        let path = UIBezierPath(arcCenter: midPoint,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        [trackLayer,  progressLayer].forEach {
            $0.fillColor = UIColor.clear.cgColor
        }
        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        progressLayer.strokeEnd = 0
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
        updateAllProperties()
    }
    
    // MARK: - Update
    private func recreateProgressView() {
        switch progressViewStyle {
        case .bar: createBarProgressLayers()
        case .circular: createCircularProgressLayer()
        }
    }
    
    private func updateProgressViewStyle() {
        recreateProgressView()
    }
    
    private func updateAllProperties() {
        updateTrackColor()
        updateProgressColor()
        updateLineWidth()
        updateLineCapStyle()
        updateProgress()
    }
    
    private func updateTrackColor() {
        switch progressViewStyle {
        case .bar:
            trackLayer.fillColor = trackTintColor.cgColor
        case .circular:
            trackLayer.strokeColor = trackTintColor.cgColor
        }
    }
    
    private func updateProgressColor() {
        switch progressViewStyle {
        case .bar:
            progressLayer.fillColor = progressTintColor.cgColor
        case .circular:
            progressLayer.strokeColor = progressTintColor.cgColor
        }
    }
    
    private func updateLineWidth() {
        switch progressViewStyle {
        case .bar:
            trackLayer.lineWidth = 0
            progressLayer.lineWidth = 0
        case .circular:
            trackLayer.lineWidth = lineWidth
            progressLayer.lineWidth = lineWidth
        }
    }
    
    private func  updateLineCapStyle() {
        trackLayer.lineCap = lineCapStyle
        progressLayer.lineCap = lineCapStyle
    }
    
    // MARK: - Progress
    private func updateProgress() {
        switch progressViewStyle {
        case .bar:
            let rect = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width * CGFloat(progress), height: bounds.height))
            let path = UIBezierPath(roundedRect: rect, cornerRadius: bounds.height / 2)
            progressLayer.path = path.cgPath
        case .circular:
            progressLayer.strokeEnd = CGFloat(progress)
        }
    }
    
    // MARK: - Auto complete
    func autoComplete(duration: TimeInterval, from startProgress: Float = 0, to endProgress: Float = 1, completion: (() -> Void)? = nil) {
        progress = startProgress
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = startProgress
        animation.toValue = endProgress
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        CATransaction.setCompletionBlock {
            completion?()
        }
        progress = endProgress
        progressLayer.add(animation, forKey: nil)
        CATransaction.commit()
    }
}
