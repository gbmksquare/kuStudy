//
//  SummaryHeaderItemCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 5. 31..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import UIKit

class SummaryHeaderItemCell: UICollectionViewCell {
    private lazy var containerView = UIView()
    private lazy var stackView = UIStackView()
    lazy var titleLabel = UILabel()
    lazy var valueLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func updateAccessibleDescription() {
        contentView.accessibilityValue = "\(titleLabel.text ?? "") \(valueLabel.text ?? "") \(descriptionLabel.text ?? "")"
    }
    
    // MARK: - Setup
    private func setup() {
        containerView.backgroundColor = .white // #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        containerView.layer.cornerRadius = 9
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 6
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = #colorLiteral(red: 0.9601849914, green: 0.9601849914, blue: 0.9601849914, alpha: 1).cgColor
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 2 // UIStackView.spacingUseDefault
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
        
        let metrics = UIFontMetrics(forTextStyle: .body)
        
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = metrics.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .semibold))
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        stackView.addArrangedSubview(titleLabel)
        
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = metrics.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .medium))
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        stackView.addArrangedSubview(descriptionLabel)
        
        valueLabel.textColor = .black
        valueLabel.textAlignment = .left
        valueLabel.font = metrics.scaledFont(for: UIFont.systemFont(ofSize: 28, weight: .regular))
        stackView.addArrangedSubview(valueLabel)
        
        contentView.isAccessibilityElement = true
        titleLabel.isAccessibilityElement = false
        descriptionLabel.isAccessibilityElement = false
        valueLabel.isAccessibilityElement = false
        contentView.accessibilityTraits = UIAccessibilityTraitStaticText
    }
}
