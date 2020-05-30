//
//  TipItemCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/05/30.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import StoreKit

class TipItemCell: RoundCornerCell {
    // MARK: - View
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold).scaled(for: .headline)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular).scaled(for: .body)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold).scaled(for: .body)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch traitCollection.preferredContentSizeCategory {
        case let category where category > .accessibilityExtraLarge:
            mainStackView.axis = .vertical
            mainStackView.alignment = .fill
            priceLabel.textAlignment = .justified
        default:
            mainStackView.axis = .horizontal
            mainStackView.alignment = .center
            priceLabel.textAlignment = .right
        }
    }
    
    // MARK: - Setup
    private func setup() {
        contentView.isAccessibilityElement = true
        contentView.accessibilityTraits = UIAccessibilityTraits.staticText
        
        [titleLabel, descriptionLabel, priceLabel].forEach {
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
        
        mainStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        mainStackView.addArrangedSubview(priceLabel)
    }
    
    // MARK: - Popualte
    private func reset() {
        titleLabel.text = nil
        descriptionLabel.text = nil
        priceLabel.text = nil
        contentView.accessibilityLabel = nil
    }
    
    func populate(product: SKProduct) {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .default
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        let priceString = formatter.string(for: product.price) ?? "--"
        
        titleLabel.text = product.localizedTitle
        descriptionLabel.text = product.localizedDescription
        priceLabel.text = priceString
        contentView.accessibilityLabel = "\(product.localizedTitle) \(product.localizedDescription) \(priceString)"
    }
}
