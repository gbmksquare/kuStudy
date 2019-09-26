//
//  StatusView.swift
//  kuStudy Today Extension
//
//  Created by BumMo Koo on 2017. 8. 4..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import SnapKit

class StatusView: UIView {
    private lazy var vibracyView: UIVisualEffectView = {
        let effect = UIVibrancyEffect.widgetSecondary()
        return UIVisualEffectView(effect: effect)
    }()
    private lazy var indicator = UIActivityIndicatorView()
    private lazy var label = UILabel()
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        setLoadingState()
    }
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = .clear
        
        // Vibrancy
        addSubview(vibracyView)
        vibracyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Indicator
        indicator.style = .medium
        indicator.hidesWhenStopped = true
        
        // Label
        label.text = Localizations.Table.Label.Error
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        
        [indicator, label].forEach { vibracyView.contentView.addSubview($0) }
        
        indicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(vibracyView.snp.centerX)
            make.centerY.equalTo(vibracyView.snp.centerY)
        }
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(vibracyView.snp.centerX)
            make.centerY.equalTo(vibracyView.snp.centerY)
        }
    }
    
    // MARK: - Action
    func setLoadingState() {
        indicator.startAnimating()
        label.isHidden = true
    }
    
    func setErrorState(message: String? = nil) {
        indicator.stopAnimating()
        label.isHidden = false
        label.text = message ?? Localizations.Table.Label.Error
    }
}
