//
//  AppFooter.swift
//  kuStudy
//
//  Created by BumMo Koo on 24/07/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import UIKit

class AppVersionFooterView: UIView {
    private lazy var stackView = UIStackView()
    private lazy var iconImageView = UIImageView()
    private lazy var textStackView = UIStackView()
    private lazy var applicationLabel = UILabel()
    private lazy var developerLabel = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(readableContentGuide.snp.leading)
            make.trailing.equalTo(readableContentGuide.snp.trailing)
        }
        
        iconImageView.image = UIImage(named: "AppIcon60x60")
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.backgroundColor = .systemFill
        iconImageView.layer.cornerRadius = 8
        iconImageView.layer.masksToBounds = true
        iconImageView.accessibilityIgnoresInvertColors = true
        stackView.addArrangedSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.width.equalTo(29)
            make.height.equalTo(iconImageView.snp.width)
        }
        
        let caption1Metric = UIFontMetrics(forTextStyle: .caption1)
        
        textStackView.axis = .vertical
        textStackView.alignment = .fill
        textStackView.distribution = .fill
        textStackView.spacing = caption1Metric.scaledValue(for: 6)
        stackView.addArrangedSubview(textStackView)
        
        applicationLabel.text = UIApplication.shared.applicationName + " " +  UIApplication.shared.versionString
//        applicationLabel.accessibilityValue = ""
        developerLabel.text = "BumMo Koo"
//        developerLabel.accessibilityValue = ""
        [applicationLabel, developerLabel].forEach {
            $0.textColor = .darkGray
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.adjustsFontForContentSizeCategory = true
            $0.font = caption1Metric.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .medium))
            textStackView.addArrangedSubview($0)
        }
    }
}
