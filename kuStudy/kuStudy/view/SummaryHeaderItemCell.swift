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
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = UIStackView.spacingUseDefault
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(4)
        }
        
        let metrics = UIFontMetrics(forTextStyle: .body)
        
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = metrics.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .semibold))
        stackView.addArrangedSubview(titleLabel)
        
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center
        valueLabel.font = metrics.scaledFont(for: UIFont.systemFont(ofSize: 28, weight: .regular))
        stackView.addArrangedSubview(valueLabel)
        
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = metrics.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .medium))
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    // MARK: - Action
    func setBackgroundColor(_ color: UIColor) {
        containerView.backgroundColor = color
    }
}
