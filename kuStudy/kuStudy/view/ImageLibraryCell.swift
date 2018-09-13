//
//  ImageLibraryCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 04/09/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class ImageLibraryCell: UITableViewCell {
    private lazy var indicator = UIView()
    private lazy var stackView = UIStackView()
    private lazy var thumbnailContainerView = UIView()
    private lazy var thumbnailImageView = UIImageView()
    private lazy var libraryStackView = UIStackView()
    private lazy var titleLabel = UILabel()
    private lazy var informationStackView = UIStackView()
    private lazy var availableStackView = TitleValueStackView()
    
    var libraryData: LibraryData? { didSet { populate() } }
    
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.preferredContentSizeCategory >= .accessibilityExtraLarge {
            informationStackView.axis = .vertical
        } else {
            informationStackView.axis = .horizontal
        }
    }
    
    // MARK: - Populate
    private func populate() {
        let data = libraryData
        let noData = Localizations.Common.NoData
        indicator.backgroundColor = data?.availablePercentageColor ?? .lightGray
        thumbnailImageView.image = data?.media?.thumbnail
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
        stackView.spacing = bodyMetrics.scaledValue(for: 8)
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.equalTo(indicator.snp.trailing).offset(bodyMetrics.scaledValue(for: 12))
            make.trailing.equalTo(readableContentGuide.snp.trailing).inset(bodyMetrics.scaledValue(for: 8))
            make.top.equalToSuperview().offset(bodyMetrics.scaledValue(for: 8))
            make.bottom.equalToSuperview().inset(bodyMetrics.scaledValue(for: 8))
        }
        
        thumbnailContainerView.backgroundColor = .white
        stackView.addArrangedSubview(thumbnailContainerView)
        
        thumbnailImageView.backgroundColor = .placeholder
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.accessibilityIgnoresInvertColors = true
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.layer.cornerRadius = 30
        thumbnailContainerView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        libraryStackView.axis = .vertical
        libraryStackView.alignment = .fill
        libraryStackView.distribution = .fill
        libraryStackView.spacing = bodyMetrics.scaledValue(for: 6)
        stackView.addArrangedSubview(libraryStackView)
        
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.font = headlineMetrics.scaledFont(for: UIFont.systemFont(ofSize: 16, weight: .bold))
        libraryStackView.addArrangedSubview(titleLabel)
        
        informationStackView.axis = .horizontal
        informationStackView.alignment = .fill
        informationStackView.distribution = .fillEqually
        informationStackView.spacing = UIStackView.spacingUseDefault
        libraryStackView.addArrangedSubview(informationStackView)
        
        availableStackView.titleLabel.text = Localizations.Common.Available
        [availableStackView].forEach {
            informationStackView.addArrangedSubview($0)
        }
        
        reset()
    }
}
