//
//  RefreshEffectView.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 27..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit

class RefreshEffectView: UIView {
    private lazy var effectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: nil)
        return view
    }()
    private lazy var indicator = UIActivityIndicatorView()
    
    private var inAnimator: UIViewPropertyAnimator?
    private var outAnimator: UIViewPropertyAnimator?
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    // MARK: - Action
    func startRefreshing() {
        outAnimator?.stopAnimation(true)
        
        guard inAnimator == nil else { return }
        inAnimator = UIViewPropertyAnimator(duration: 0.75, curve: .easeIn, animations: { [unowned self] in
            self.effectView.effect = UIBlurEffect(style: .dark)
            self.indicator.alpha = 1
            self.inAnimator = nil
        })
        inAnimator?.startAnimation()
    }
    
    func endRefreshing() {
        inAnimator?.stopAnimation(false)
        
        guard outAnimator == nil else { return }
        outAnimator = UIViewPropertyAnimator(duration: 0.75, curve: .easeIn, animations: { [unowned self] in
            self.effectView.effect = nil
            self.indicator.alpha = 0
            self.outAnimator = nil
        })
        outAnimator?.startAnimation(afterDelay: 0.5)
    }
    
    // MARK: - Setup
    private func setup() {
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.alpha = 0
        indicator.startAnimating()
        
        // Layout
        addSubview(effectView)
        effectView.contentView.addSubview(indicator)
        
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(indicator.snp.width)
        }
    }
}
