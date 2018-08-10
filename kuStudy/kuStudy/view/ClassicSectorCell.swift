//
//  SectorCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 25..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class ClassicSectorCell: UITableViewCell {
    private lazy var indicator = UIView()
    
    private lazy var stack = UIStackView()
    
    private lazy var titleLabel = UILabel()
    
    private lazy var dataStack = UIStackView()
    
    private lazy var availableStack = UIStackView()
    private lazy var availableSeatsLabel = UILabel()
    private lazy var availableLabel = UILabel()
    
    private lazy var progressView = SeatsProgressView()
    
    private lazy var infoStack = UIStackView()
    private lazy var openInfoView = MiniInfoView()
    private lazy var closeInfoView = MiniInfoView()
    private lazy var disabledInfoView = MiniInfoView()
    
    var sectorData: SectorData? { didSet { populate() } }
    
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
        if traitCollection.preferredContentSizeCategory >= .extraExtraExtraLarge {
            setupDataStackVertical()
        } else {
            setDataStackHorizontal()
        }
    }
    
    // MARK: - Populate
    private func populate() {
        let data = sectorData
        let noData = Localizations.Common.NoData
        indicator.backgroundColor = data?.availablePercentageColor ?? .lightGray
        titleLabel.text = data?.name ?? noData
        availableSeatsLabel.text = data?.available?.readable ?? noData
        progressView.sectorData = data
        
        openInfoView.imageView.image = #imageLiteral(resourceName: "AppIcon60x60")
        openInfoView.titleLabel.text = "Open"
        openInfoView.subtitleLabel.text = data?.openTime?.readable ?? noData
        closeInfoView.imageView.image = #imageLiteral(resourceName: "AppIcon60x60")
        closeInfoView.titleLabel.text = "Close"
        closeInfoView.subtitleLabel.text = data?.closeTime?.readable ?? noData
        if let disabledOnly = data?.disabledOnly, disabledOnly > 0 {
            disabledInfoView.imageView.image = #imageLiteral(resourceName: "AppIcon60x60")
            disabledInfoView.titleLabel.text = Localizations.Common.Disabled
            disabledInfoView.subtitleLabel.text = data?.disabledOnly?.readable ?? noData
        } else {
            disabledInfoView.imageView.image = nil
            disabledInfoView.titleLabel.text = nil
            disabledInfoView.subtitleLabel.text = nil
        }
    }
    
    private func reset() {
        indicator.backgroundColor = UIColor.lightGray
        titleLabel.text = Localizations.Common.NoData
        availableSeatsLabel.text = Localizations.Common.NoData
        progressView.sectorData = nil
    }
    
    // MARK: - Setup
    private func setup() {
        setupView()
        setupLayout()
        setupContent()
        reset()
    }
    
    private func setupContent() {
        availableLabel.text = Localizations.Common.Available
    }
    
    private func setupView() {
        indicator.accessibilityIgnoresInvertColors = true
        indicator.layer.cornerRadius = 7
        indicator.layer.masksToBounds = true
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 6
        
        setDataStackHorizontal()
        
        availableStack.axis = .vertical
        availableStack.alignment = .fill
        availableStack.distribution = .fillProportionally
        availableStack.spacing = 0
        
        infoStack.axis = .horizontal
        infoStack.alignment = .leading
        infoStack.distribution = .fillEqually
        infoStack.spacing = 4
        
        let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
        let titleMetrics = UIFontMetrics(forTextStyle: .title1)
        let captionMetrics = UIFontMetrics(forTextStyle: .caption1)
        
        titleLabel.font = headlineMetrics.scaledFont(for: UIFont.systemFont(ofSize: 18, weight: .semibold))
        availableSeatsLabel.font = titleMetrics.scaledFont(for: UIFont.systemFont(ofSize: 30, weight: .light))
        availableLabel.font = captionMetrics.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .semibold))
        
        [titleLabel, availableSeatsLabel, availableLabel].forEach {
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
        }
        
        availableLabel.textColor = .lightGray
    }
    
    private func setupLayout() {
        [indicator, stack].forEach { contentView.addSubview($0) }
        [titleLabel, dataStack].forEach { stack.addArrangedSubview($0) }
        /// !!!: Disabled info stack
//        [titleLabel, dataStack, infoStack].forEach { stack.addArrangedSubview($0) }
        [availableStack, progressView].forEach { dataStack.addArrangedSubview($0) }
        [availableSeatsLabel, availableLabel].forEach { availableStack.addArrangedSubview($0) }
        [openInfoView, closeInfoView, disabledInfoView].forEach { infoStack.addArrangedSubview($0) }
        
        indicator.snp.makeConstraints { (make) in
            make.width.equalTo(14)
            make.height.equalTo(14)
            make.centerY.equalTo(dataStack.snp.centerY)
            make.leading.equalTo(contentView.readableContentGuide.snp.leading).inset(8)
        }
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).inset(12)
            make.leading.equalTo(indicator.snp.trailing).offset(12)
            make.trailing.equalTo(contentView.readableContentGuide.snp.trailing).inset(8)
            make.bottom.equalTo(contentView).inset(12)
        }
//        progressView.snp.makeConstraints { (make) in
//            make.width.equalTo(dataStack).multipliedBy(0.6)
//        }
    }
}

extension ClassicSectorCell {
    private func setDataStackHorizontal() {
        dataStack.axis = .horizontal
        dataStack.alignment = .lastBaseline
        dataStack.distribution = .fillEqually
        dataStack.spacing = UIStackView.spacingUseDefault
    }
    
    private func setupDataStackVertical() {
        dataStack.axis = .vertical
        dataStack.alignment = .fill
        dataStack.distribution = .fillProportionally
        dataStack.spacing = UIStackView.spacingUseDefault
    }
}