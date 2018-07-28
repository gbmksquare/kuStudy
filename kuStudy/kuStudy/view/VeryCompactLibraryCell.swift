//
//  VeryCompactLibraryCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 7. 28..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class VeryCompactLibraryCell: UITableViewCell {
    private lazy var indicator = UIView()
    private lazy var stackView = UIStackView()
    private lazy var titleLabel = UILabel()
    private lazy var availableStackView = TitleValueStackView()
    
    var libraryData: LibraryData? { didSet { populate() } }
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    // MARK: - View
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.preferredContentSizeCategory >= .accessibilityLarge {
            stackView.axis = .vertical
            availableStackView.axis = .vertical
            availableStackView.alignment = .fill
        } else {
            stackView.axis = .horizontal
            availableStackView.axis = .horizontal
            availableStackView.alignment = .center
        }
    }
    
    // MARK: - Populate
    private func populate() {
        let data = libraryData
        let noData = Localizations.Common.NoData
        indicator.backgroundColor = data?.availablePercentageColor ?? .lightGray
        titleLabel.text = data?.libraryName ?? noData
        availableStackView.valueLabel.text = data?.available.readable ?? noData
    }
    
    private func reset() {
        indicator.backgroundColor = UIColor.lightGray
        titleLabel.text = Localizations.Common.NoData
        availableStackView.valueLabel.text = Localizations.Common.NoData
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = indicator.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        indicator.backgroundColor = color
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = indicator.backgroundColor
        super.setSelected(selected, animated: animated)
        indicator.backgroundColor = color
    }
    
    // MARK: - Setup
    private func setup() {
        let selectionView = UIView()
        selectionView.backgroundColor = .lightTint
        selectedBackgroundView = selectionView
        
        indicator.backgroundColor = .lightGray
        indicator.layer.cornerRadius = 7
        indicator.accessibilityIgnoresInvertColors = true
        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(readableContentGuide.snp.leading)
            make.width.equalTo(14)
            make.height.equalTo(14)
        }
        
        let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
        let bodyMetrics = UIFontMetrics(forTextStyle: .body)
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = bodyMetrics.scaledValue(for: 6)
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.equalTo(indicator.snp.trailing).offset(bodyMetrics.scaledValue(for: 12))
            make.trailing.equalTo(readableContentGuide.snp.trailing).inset(bodyMetrics.scaledValue(for: 16))
            make.top.equalToSuperview().offset(bodyMetrics.scaledValue(for: 8))
            make.bottom.equalToSuperview().inset(bodyMetrics.scaledValue(for: 8))
        }
        
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.font = headlineMetrics.scaledFont(for: UIFont.systemFont(ofSize: 16, weight: .bold))
        stackView.addArrangedSubview(titleLabel)
        
        availableStackView.titleLabel.text = Localizations.Common.Available
        availableStackView.axis = .horizontal
        availableStackView.alignment = .center
        availableStackView.distribution = .fill
        availableStackView.spacing = bodyMetrics.scaledValue(for: 4)
        availableStackView.valueLabel.textAlignment = .right
        availableStackView.titleLabel.textAlignment = .right
        availableStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        availableStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        availableStackView.titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        availableStackView.valueLabel.setContentHuggingPriority(.required, for: .horizontal)
        stackView.addArrangedSubview(availableStackView)
    }
}
