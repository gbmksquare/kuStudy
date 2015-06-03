//
//  ProgressView.swift
//  LinearProgressImageGenerator
//
//  Created by 구범모 on 2015. 6. 3..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit

@IBDesignable class ProgressView: UIView {
    @IBInspectable var progress = 0.0 {
        didSet {
            progressView?.hidden = progress == 0 ? true : false
            progressView?.frame = CGRect(origin: frame.origin,
                size: CGSize(width: frame.width * CGFloat(progress), height: frame.height))
            switch progress {
            case let p where p > 0.9: progressColor = UIColor(hue:0.01, saturation:0.74, brightness:0.94, alpha:1)
            case let p where p > 0.8: progressColor = UIColor(hue:0.09, saturation:0.82, brightness:0.99, alpha:1)
            case let p where p > 0.7: progressColor = UIColor(hue:0.12, saturation:0.79, brightness:0.99, alpha:1)
            default: progressColor = UIColor(hue:0.34, saturation:0.52, brightness:0.68, alpha:1)
            }
        }
    }
    @IBInspectable var progressColor = UIColor.greenColor() {
        didSet {
            progressView?.backgroundColor = progressColor
        }
    }
    @IBInspectable var progressBackgroundColor = UIColor.darkGrayColor()
    
    private var progressView: UIView?
    private var progressBackgroundView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.clearColor()
        opaque = false
        
        progressView = UIView(frame: bounds)
        progressBackgroundView = UIView(frame: bounds)
        
        progressView?.backgroundColor = progressColor
        progressBackgroundView?.backgroundColor = progressBackgroundColor
        
        progressView?.layer.cornerRadius = bounds.height / 2
        progressBackgroundView?.layer.cornerRadius = bounds.height / 2
        
        addSubview(progressBackgroundView!)
        addSubview(progressView!)
    }
}
