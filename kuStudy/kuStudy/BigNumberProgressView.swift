//
//  BigNumberProgressView.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/07.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

class BigNumberProgressView: UIView {
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = UIFont.systemFont(ofSize: 60, weight: .semibold).scaled(for: .body)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var remainingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 60, weight: .semibold).scaled(for: .body)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var progressView: GBMProgressView = {
        let progress = GBMProgressView(progressViewStyle: .bar)
        progress.trackTintColor = .systemGray4
        progress.progress = 0
        progress.lineWidth = 12
        progress.accessibilityIgnoresInvertColors = true
        return progress
    }()
    
    private lazy var progressTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold).scaled(for: .footnote)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private lazy var remainingTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold).scaled(for: .footnote)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupLayout()
    }
    
    // MARK: - Setup
    private func setup() {
        isAccessibilityElement = true
        accessibilityTraits = UIAccessibilityTraits.staticText
        
        progressLabel.text = "0"
        remainingLabel.text = "0"
        progressTitleLabel.text = "occupied".localizedFromKit().uppercased()
        remainingTitleLabel.text = "available".localizedFromKit().uppercased()
        
        [progressLabel, remainingLabel, progressTitleLabel, remainingTitleLabel].forEach {
            $0.isAccessibilityElement = false
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
        }
    }
    
    private func setupLayout() {
        addSubview(progressLabel)
        addSubview(remainingLabel)
        addSubview(progressView)
        addSubview(progressTitleLabel)
        addSubview(remainingTitleLabel)
        
        progressLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.firstBaseline.equalTo(progressView.snp.top).offset(-4)
        }
        
        remainingLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.firstBaseline.equalTo(progressView.snp.top).offset(-4)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(progressTitleLabel.snp.top).offset(-2)
            make.height.equalTo(12)
        }
        
        progressTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        remainingTitleLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Populate
    func populate(progress: Double, progressValue: Int, remainingValue: Int) {
        progressView.progress = Float(progress)
        progressView.progressTintColor = progress.color
        progressLabel.text = progressValue.readable
        remainingLabel.text = remainingValue.readable
        accessibilityLabel = "Lorem ipsum" // TODO: Localize
    }
}
