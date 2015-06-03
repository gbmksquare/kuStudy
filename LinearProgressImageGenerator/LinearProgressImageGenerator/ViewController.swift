//
//  ViewController.swift
//  LinearProgressImageGenerator
//
//  Created by 구범모 on 2015. 6. 3..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let flipbook = Flipbook()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progressView = ProgressView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300, height: 4)))
        
        flipbook.renderTargetView(progressView, imagePrefix: "linear", frameCount: 101) { (view, frame) -> Void in
            progressView.progress = Double(frame) * 0.01
        }
        
        println(NSTemporaryDirectory())
    }
}

