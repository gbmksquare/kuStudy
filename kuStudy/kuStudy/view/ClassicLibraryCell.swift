//
//  LibraryCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 11. 16..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class ClassicLibraryCell: UITableViewCell {
    private lazy var indicator = UIView()
    
    private lazy var stack = UIStackView()
    
    private lazy var titleLabel = UILabel()
    
    private lazy var imageDataStack = UIStackView()
    
    private lazy var thumbnailView = UIImageView()
    
    private lazy var availableStack = UIStackView()
    private lazy var availableSeatsLabel = UILabel()
    private lazy var availableLabel = UILabel()
    
    private lazy var progressView = SeatsProgressView()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = min(UIFontMetrics(forTextStyle: .body).scaledValue(for: 70), 120)
        thumbnailView.layer.cornerRadius = height / 2
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = indicator.backgroundColor
        let colors = progressView.getColors()
        super.setHighlighted(highlighted, animated: animated)
        indicator.backgroundColor = color
        progressView.setColors(colors: colors)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = indicator.backgroundColor
        let colors = progressView.getColors()
        super.setSelected(selected, animated: animated)
        indicator.backgroundColor = color
        progressView.setColors(colors: colors)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        thumbnailView.snp.remakeConstraints { (make) in
            make.width.equalTo(thumbnailView.snp.height)
            let height = min(UIFontMetrics(forTextStyle: .body).scaledValue(for: 70), 120)
            make.height.equalTo(height)
        }
    }
    
    // MARK: - Populate
    private func populate() {
        let data = libraryData
        let noData = Localizations.Common.NoData
        indicator.backgroundColor = data?.availablePercentageColor ?? .lightGray
        titleLabel.text = data?.libraryName ?? noData
        availableSeatsLabel.text = data?.available.readable ?? noData
        progressView.libraryData = data
        thumbnailView.image = data?.media?.thumbnail
    }
    
    private func reset() {
        indicator.backgroundColor = UIColor.lightGray
        titleLabel.text = Localizations.Common.NoData
        availableSeatsLabel.text = Localizations.Common.NoData
        progressView.sectorData = nil
    }
    
    @objc private func handleShouldUpdateImage(_ notification: Notification) {
        guard let data = libraryData else { return }
        UIView.transition(with: thumbnailView,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.thumbnailView.image = data.media?.thumbnail
            }, completion: nil)
    }
    
    // MARK: - Setup
    private func setup() {
        setupView()
        setupLayout()
        setupContent()
        reset()
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleShouldUpdateImage(_:)), name: MediaManager.shouldUpdateImageNotification, object: nil)
    }
    
    private func setupContent() {
        availableLabel.text = Localizations.Common.Available
    }
    
    private func setupView() {
        let selectionView = UIView()
        selectionView.backgroundColor = .lightTint
        selectedBackgroundView = selectionView
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 6
        
        imageDataStack.axis = .horizontal
        imageDataStack.alignment = .center
        imageDataStack.distribution = .fill
        imageDataStack.spacing = 16
        
        availableStack.axis = .vertical
        availableStack.alignment = .fill
        availableStack.distribution = .fillProportionally
        availableStack.spacing = 0
        
        indicator.accessibilityIgnoresInvertColors = true
        indicator.layer.cornerRadius = 7
        indicator.layer.masksToBounds = true
        
        thumbnailView.backgroundColor = .placeholder
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.clipsToBounds = true
        thumbnailView.accessibilityIgnoresInvertColors = true
        
        let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
        let titleMetrics = UIFontMetrics(forTextStyle: .title1)
        let captionMetrics = UIFontMetrics(forTextStyle: .caption1)
        
        titleLabel.font = headlineMetrics.scaledFont(for: UIFont.systemFont(ofSize: 18, weight: .semibold))
        availableSeatsLabel.font = titleMetrics.scaledFont(for: UIFont.systemFont(ofSize: 30, weight: .light))
        availableLabel.font = captionMetrics.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .semibold))
        
        titleLabel.numberOfLines = 0
        
        [titleLabel, availableSeatsLabel, availableLabel].forEach {
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        
        availableLabel.textColor = .lightGray
    }
    
    private func setupLayout() {
        [indicator, stack].forEach { contentView.addSubview($0) }
        [titleLabel, imageDataStack].forEach { stack.addArrangedSubview($0) }
        [thumbnailView, availableStack].forEach { imageDataStack.addArrangedSubview($0) }
        [availableSeatsLabel, availableLabel].forEach { availableStack.addArrangedSubview($0) }
        
        indicator.snp.makeConstraints { (make) in
            make.width.equalTo(14)
            make.height.equalTo(14)
            make.centerY.equalTo(imageDataStack.snp.centerY)
            make.leading.equalTo(contentView.readableContentGuide.snp.leading).inset(8)
        }
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).inset(12)
            make.leading.equalTo(indicator.snp.trailing).offset(12)
            make.trailing.equalTo(contentView.readableContentGuide.snp.trailing).inset(8)
            make.bottom.equalTo(contentView).inset(12)
        }
        thumbnailView.snp.makeConstraints { (make) in
            make.width.equalTo(thumbnailView.snp.height)
            let height = min(UIFontMetrics(forTextStyle: .body).scaledValue(for: 70), 120)
            make.height.equalTo(height)
        }
    }
}
