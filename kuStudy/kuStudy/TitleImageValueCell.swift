//
//  TitleImageValueCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/03/29.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

class TitleImageValueCell: RoundCornerCell {
    // MARK: - View
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2.scaled(for: .body)
        return stackView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = .label
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold).scaled(for: .body)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium).scaled(for: .body)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    // MARK: - State
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = .quaternarySystemFill
            } else {
                backgroundColor = .secondarySystemGroupedBackground
            }
        }
    }
    
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
        contentView.accessibilityTraits = UIAccessibilityTraits.button
        contentView.accessibilityLabel = titleLabel.accessibilityLabel
        
        [titleLabel, valueLabel].forEach {
            $0.isAccessibilityElement = false
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
        }
    }
    
    private func setupLayout() {
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.edges.lessThanOrEqualToSuperview()
            make.center.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(valueLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(20.scaled(for: .body))
            make.height.equalTo(imageView.snp.width)
        }
    }
    
    // MARK: - Popualte
    private func reset() {
        titleLabel.text = nil
        valueLabel.text = nil
        imageView.image = nil
        contentView.accessibilityLabel = nil
    }
    
    func populate(title: String, value: String, image: UIImage?) {
        titleLabel.text = title
        valueLabel.text = value
        imageView.image = image
        contentView.accessibilityLabel = "\(title) \(value)"
    }
}
