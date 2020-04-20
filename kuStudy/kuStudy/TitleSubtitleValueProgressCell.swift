//
//  TitleSubtitleValueProgressCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/12.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

class TitleSubtitleValueProgressCell: RoundCornerCell {
    // MARK: - View
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 2.scaled(for: .body)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold).scaled(for: .callout)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold).scaled(for: .headline)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium).scaled(for: .body)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var progressView: GBMProgressView = {
        let progress = GBMProgressView(progressViewStyle: .bar)
        progress.trackTintColor = .systemGray4
        progress.progress = 0
        progress.lineWidth = 4
        progress.accessibilityIgnoresInvertColors = true
        return progress
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    // MARK: - Setup
    private func setup() {
        contentView.isAccessibilityElement = true
        contentView.accessibilityTraits = UIAccessibilityTraits.staticText
        [titleLabel, subtitleLabel, valueLabel].forEach {
            $0.isAccessibilityElement = false
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
        }
    }
    
    private func setupLayout() {
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(valueLabel)
        mainStackView.addArrangedSubview(progressView)
        
        progressView.snp.makeConstraints { (make) in
            make.height.equalTo(4)
        }
    }
    
    // MARK: - Popualte
    private func reset() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        valueLabel.text = nil
        progressView.progress = 0
        contentView.accessibilityLabel = nil
    }
    
    func populate(title: String, subtitle: String, value: String, progress: Double) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        valueLabel.text = value
        progressView.progress = Float(progress)
        progressView.progressTintColor = progress.color
        contentView.accessibilityLabel = "" // TODO: Localize
    }
}
