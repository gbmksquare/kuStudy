//
//  SectorCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 25..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class SectorCell: UITableViewCell {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicator.layer.cornerRadius = indicator.bounds.width / 2
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
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 12
        
        dataStack.axis = .horizontal
        dataStack.alignment = .lastBaseline
        dataStack.distribution = .equalSpacing
        dataStack.spacing = 8
        
        availableStack.axis = .vertical
        availableStack.alignment = .fill
        availableStack.distribution = .fillProportionally
        availableStack.spacing = 0
        
        infoStack.axis = .horizontal
        infoStack.alignment = .leading
        infoStack.distribution = .fillEqually
        infoStack.spacing = 4
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        availableSeatsLabel.font = UIFont.systemFont(ofSize: 34, weight: .light)
        availableLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        availableLabel.textColor = .lightGray
    }
    
    private func setupLayout() {
        [indicator, stack].forEach { contentView.addSubview($0) }
        [titleLabel, dataStack, infoStack].forEach { stack.addArrangedSubview($0) }
        [availableStack, progressView].forEach { dataStack.addArrangedSubview($0) }
        [availableSeatsLabel, availableLabel].forEach { availableStack.addArrangedSubview($0) }
        [openInfoView, closeInfoView, disabledInfoView].forEach { infoStack.addArrangedSubview($0) }
        
        indicator.snp.makeConstraints { (make) in
            make.width.equalTo(13)
            make.height.equalTo(13)
            make.centerY.equalTo(dataStack.snp.centerY)
            make.leading.equalTo(readableContentGuide).inset(8)
        }
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).inset(12)
            make.leading.equalTo(indicator.snp.trailing).offset(12)
            make.trailing.equalTo(readableContentGuide).inset(8)
            make.bottom.equalTo(contentView).inset(12)
        }
        progressView.snp.makeConstraints { (make) in
            make.width.equalTo(dataStack).multipliedBy(0.6)
        }
    }
}
