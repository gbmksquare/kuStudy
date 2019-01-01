//
//  AppIconCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 01/01/2019.
//  Copyright © 2019 gbmKSquare. All rights reserved.
//

import UIKit

class AppIconCell: UITableViewCell {
    private lazy var stackView = UIStackView()
    lazy var iconImageView = UIImageView()
    private lazy var textStackView = UIStackView()
    lazy var iconNameLabel = UILabel()
    lazy var iconDescriptionLabel = UILabel()
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    // MARK: - View
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    // MARK: - Populate
    private func reset() {
        iconImageView.image = nil
        iconNameLabel.text = nil
        iconDescriptionLabel.text = nil
    }
    
    private func setup() {
        let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
        let bodyMetrics = UIFontMetrics(forTextStyle: .body)
        
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = bodyMetrics.scaledValue(for: 12)
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(bodyMetrics.scaledValue(for: 8))
            make.bottom.equalToSuperview().inset(bodyMetrics.scaledValue(for: 8))
            make.leading.equalTo(contentView.readableContentGuide.snp.leading)
            make.trailing.equalTo(contentView.readableContentGuide.snp.trailing)
        }
        
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 16
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1).cgColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.accessibilityIgnoresInvertColors = true
        stackView.addArrangedSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.distribution = .fill
        textStackView.spacing = bodyMetrics.scaledValue(for: 4)
        stackView.addArrangedSubview(textStackView)
        
        iconNameLabel.textColor = .black
        iconNameLabel.numberOfLines = 0
        iconNameLabel.lineBreakMode = .byWordWrapping
        iconNameLabel.adjustsFontSizeToFitWidth = true
        iconNameLabel.adjustsFontForContentSizeCategory = true
        iconNameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        iconNameLabel.font = headlineMetrics.scaledFont(for: UIFont.systemFont(ofSize: 16, weight: .bold))
        textStackView.addArrangedSubview(iconNameLabel)
        
        iconDescriptionLabel.textColor = .gray
        iconDescriptionLabel.numberOfLines = 0
        iconDescriptionLabel.lineBreakMode = .byWordWrapping
        iconDescriptionLabel.adjustsFontSizeToFitWidth = true
        iconDescriptionLabel.adjustsFontForContentSizeCategory = true
        iconDescriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        iconDescriptionLabel.font = bodyMetrics.scaledFont(for: UIFont.systemFont(ofSize: 14))
        textStackView.addArrangedSubview(iconDescriptionLabel)
    }
}
