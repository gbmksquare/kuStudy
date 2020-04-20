//
//  StudyAreaItemCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/06.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

class StudyAreaItemCell: RoundCornerCell {
    // MARK: - View
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
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
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium).scaled(for: .body)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold).scaled(for: .body)
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
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
        
        [titleLabel, valueLabel].forEach {
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
        
        mainStackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(24)
            make.height.equalTo(imageView.snp.width)
        }
        
        mainStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(valueLabel)
    }
    
    // MARK: - Popualte
    private func reset() {
        imageView.image = nil
        titleLabel.text = nil
        valueLabel.text = nil
        contentView.accessibilityLabel = nil
    }
    
    func populate(title: String, value: Int, systemImageName: String? = nil) {
        populate(title: title, string: value.readable, systemImageName: systemImageName)
    }
    
    func populate(title: String, boolean: Bool, systemImageName: String? = nil) {
        let string = boolean ? "yes".localizedFromKit() : "no".localizedFromKit()
        populate(title: title, string: string, systemImageName: systemImageName)
    }
    
    private func populate(title: String, string: String, systemImageName: String? = nil) {
        if let systemImageName = systemImageName {
            imageView.image = UIImage(systemName: systemImageName)
        }
        titleLabel.text = title
        valueLabel.text = string
        contentView.accessibilityLabel = "\(title) \(string)"
    }
}
