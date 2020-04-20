//
//  WeatherConditionCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/07.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

class WeatherConditionCell: RoundCornerCell {
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
        return label
    }()
    
    private lazy var itemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4.scaled(for: .body)
        return stackView
    }()
    
    private lazy var item1StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2.scaled(for: .body)
        return stackView
    }()
    
    private lazy var image1View: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = .systemTeal
        return imageView
    }()
    
    private lazy var item1TextStackView: UIStackView = {
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold).scaled(for: .headline)
        return label
    }()
    
    private lazy var value1Label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium).scaled(for: .body)
        return label
    }()
    
    private lazy var item2StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2.scaled(for: .body)
        return stackView
    }()
    
    private lazy var image2View: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = .systemTeal
        return imageView
    }()
    
    private lazy var item2TextStackView: UIStackView = {
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold).scaled(for: .headline)
        return label
    }()
    
    private lazy var value2Label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium).scaled(for: .body)
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
        
        [image1View, image2View].forEach {
            $0.isAccessibilityElement = true
            $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
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
        
        item1StackView.addArrangedSubview(image1View)
        item1StackView.addArrangedSubview(item1TextStackView)
        item1TextStackView.addArrangedSubview(subtitle1Label)
        item1TextStackView.addArrangedSubview(value1Label)
        
        item2StackView.addArrangedSubview(image2View)
        item2StackView.addArrangedSubview(item2TextStackView)
        item2TextStackView.addArrangedSubview(subtitle2Label)
        item2TextStackView.addArrangedSubview(value2Label)
        
        image1View.snp.makeConstraints { (make) in
            make.height.equalTo(image1View.snp.width)
        }
        image2View.snp.makeConstraints { (make) in
            make.height.equalTo(image2View.snp.width)
        }
    }
    
    // MARK: - Popualte
    private func reset() {
        titleLabel.text = nil
        image1View.image = nil
        subtitle1Label.text = nil
        value1Label.text = nil
        image2View.image = nil
        subtitle2Label.text = nil
        value2Label.text = nil
        contentView.accessibilityLabel = nil
    }
    
    func populate(title: String, value: String, image: UIImage?) {
        titleLabel.text = title
        image1View.image = image
        subtitle1Label.text = "오전" // TODO: Localize
        value1Label.text = value
        image2View.image = image
        subtitle2Label.text = "오전" // TODO: Localize
        value2Label.text = value
        contentView.accessibilityLabel = "오늘 날씨 존나 춥습니다. 건강하다가 깝치지 마시고 챙겨 입으시길 바랍니다." // TODO: Localize
    }
}
