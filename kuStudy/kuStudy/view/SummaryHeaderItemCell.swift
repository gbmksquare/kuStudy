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
    
    private func setup() {
        containerView.backgroundColor = .placeholder
        containerView.layer.cornerRadius = 9
        containerView.layer.masksToBounds = true
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
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8))
        }
        
        let metrics = UIFontMetrics(forTextStyle: .body)
        
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = metrics.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .semibold))
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        stackView.addArrangedSubview(titleLabel)
        
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = metrics.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .medium))
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        stackView.addArrangedSubview(descriptionLabel)
        
        valueLabel.textColor = .white
        valueLabel.textAlignment = .left
        valueLabel.font = metrics.scaledFont(for: UIFont.systemFont(ofSize: 28, weight: .regular))
        stackView.addArrangedSubview(valueLabel)
    }
    
    // MARK: - Action
    func setBackgroundColor(_ color: UIColor) {
        containerView.backgroundColor = color
    }
}
