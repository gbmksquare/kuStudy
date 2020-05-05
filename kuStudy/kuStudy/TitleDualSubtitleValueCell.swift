//
//  TitleDualSubtitleValueCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/12.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

class TitleDualSubtitleValueCell: RoundCornerCell {
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
    
    private lazy var itemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.scaled(for: .body)
        return stackView
    }()
    
    private lazy var item1StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 2.scaled(for: .body)
        return stackView
    }()
    
    private lazy var subtitle1Label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold).scaled(for: .headline)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var value1Label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium).scaled(for: .body)
        return label
    }()
    
    private lazy var progress1View: GBMProgressView = {
        let progress = GBMProgressView(progressViewStyle: .bar)
        progress.trackTintColor = .systemGray4
        progress.progress = 0
        progress.lineWidth = 4
        progress.accessibilityIgnoresInvertColors = true
        progress.setContentHuggingPriority(.required, for: .vertical)
        return progress
    }()
    
    private lazy var item2StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 2.scaled(for: .body)
        return stackView
    }()
    
    private lazy var subtitle2Label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold).scaled(for: .headline)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var value2Label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium).scaled(for: .body)
        return label
    }()
    
    private lazy var progress2View: GBMProgressView = {
        let progress = GBMProgressView(progressViewStyle: .bar)
        progress.trackTintColor = .systemGray4
        progress.progress = 0
        progress.lineWidth = 4
        progress.accessibilityIgnoresInvertColors = true
        progress.setContentHuggingPriority(.required, for: .vertical)
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
        [titleLabel, subtitle1Label, value1Label, subtitle2Label, value2Label].forEach {
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
        mainStackView.addArrangedSubview(itemsStackView)
        itemsStackView.addArrangedSubview(item1StackView)
        itemsStackView.addArrangedSubview(item2StackView)
        
        item1StackView.addArrangedSubview(subtitle1Label)
        item1StackView.addArrangedSubview(value1Label)
        item1StackView.addArrangedSubview(progress1View)
        item2StackView.addArrangedSubview(subtitle2Label)
        item2StackView.addArrangedSubview(value2Label)
        item2StackView.addArrangedSubview(progress2View)
        
        progress1View.snp.makeConstraints { (make) in
            make.height.equalTo(4)
        }
        progress2View.snp.makeConstraints { (make) in
            make.height.equalTo(4)
        }
    }
    
    // MARK: - Popualte
    private func reset() {
        titleLabel.text = nil
        subtitle1Label.text = nil
        value1Label.text = nil
        progress1View.progress = 0
        
        subtitle2Label.text = nil
        value2Label.text = nil
        progress2View.progress = 0
        
        contentView.accessibilityLabel = nil
    }
    
    func populate(title: String,
                  subtitle1: String,
                  value1: String,
                  progress1: Double,
                  subtitle2: String,
                  value2: String,
                  progress2: Double) {
        titleLabel.text = title
        
        subtitle1Label.text = subtitle1
        value1Label.text = value1
        progress1View.progress = Float(progress1)
        progress1View.progressTintColor = progress1.color
        
        subtitle2Label.text = subtitle2
        value2Label.text = value2
        progress2View.progress = Float(progress2)
        progress2View.progressTintColor = progress2.color
        
        contentView.accessibilityLabel = "" // TODO: Localize
    }
}
