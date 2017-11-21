//
//  LibraryCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 11. 16..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryCell: UITableViewCell {
    private lazy var indicator = UIView()
    
    private lazy var stack = UIStackView()
    
    private lazy var titleLabel = UILabel()
    
    private lazy var imageDataStack = UIStackView()
    
    private lazy var thumbnailView = UIImageView()
    
    private lazy var dataStack = UIStackView()
    
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
        thumbnailView.layer.cornerRadius = 70 / 2
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
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 12
        
        imageDataStack.axis = .horizontal
        imageDataStack.alignment = .center
        imageDataStack.distribution = .fill
        imageDataStack.spacing = 16
        
        dataStack.axis = .horizontal
        dataStack.alignment = .lastBaseline
        dataStack.distribution = .fillEqually
        dataStack.spacing = 8
        
        availableStack.axis = .vertical
        availableStack.alignment = .fill
        availableStack.distribution = .fillProportionally
        availableStack.spacing = 0
        
        thumbnailView.backgroundColor = #colorLiteral(red: 0.8392109871, green: 0.8391088247, blue: 0.8563356996, alpha: 1)
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            indicator.accessibilityIgnoresInvertColors = true
            thumbnailView.accessibilityIgnoresInvertColors = true
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        availableSeatsLabel.font = UIFont.systemFont(ofSize: 34, weight: .light)
        availableLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        availableLabel.textColor = .lightGray
    }
    
    private func setupLayout() {
        [indicator, stack].forEach { contentView.addSubview($0) }
        [titleLabel, imageDataStack].forEach { stack.addArrangedSubview($0) }
        [thumbnailView, dataStack].forEach { imageDataStack.addArrangedSubview($0) }
        [availableStack, progressView].forEach { dataStack.addArrangedSubview($0) }
        [availableSeatsLabel, availableLabel].forEach { availableStack.addArrangedSubview($0) }
        
        indicator.snp.makeConstraints { (make) in
            make.width.equalTo(13)
            make.height.equalTo(13)
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
            make.height.equalTo(70)
        }
//        progressView.snp.makeConstraints { (make) in
//            make.width.equalTo(imageDataStack).multipliedBy(0.3)
//        }
    }
}
