//
//  LibraryCell.swift
//  kuStudy Today Extension
//
//  Created by BumMo Koo on 2017. 8. 4..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryCell: UICollectionViewCell {
    private lazy var indicator = UIView()
    private lazy var libraryLabel = UILabel()
    private lazy var availableLabel = UILabel()
    private lazy var availableTitleLabel = UILabel()
    
    var data: LibraryData? {
        didSet {
            populate()
        }
    }
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // MARK: - View
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func populate() {
        guard let data = data, let library = data.libraryType else {
            reset()
            return
        }
        libraryLabel.text = library.name
        availableLabel.text = data.available.readable
        indicator.backgroundColor = data.availablePercentageColor
    }
    
    func reset() {
        indicator.backgroundColor = .lightGray
        libraryLabel.text = nil
        availableLabel.text = nil
    }
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = .clear
//        layer.borderColor = UIColor.lightGray.cgColor
//        layer.borderWidth = 0.5
        
        // Shadow
        indicator.layer.shadowColor = UIColor.black.cgColor
        indicator.layer.shadowOpacity = 0.1
        indicator.layer.shadowOffset = CGSize.zero
        indicator.layer.shadowRadius = 3
        indicator.layer.shouldRasterize = true
        indicator.layer.rasterizationScale = UIScreen.main.scale
        
        // Color
        let indicatorWidth: CGFloat = 12
        indicator.backgroundColor = .lightGray
        indicator.layer.cornerRadius = indicatorWidth / 2
        
        libraryLabel.textColor = .black
        availableLabel.textColor = .black
        availableTitleLabel.textColor = .darkGray
        
        // Font
        var availableLabelFont = UIFont.systemFont(ofSize: 30, weight: .light)
        if #available(iOS 11, *) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            availableLabelFont = metrics.scaledFont(for: availableLabelFont)
        }
        libraryLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        availableLabel.font = availableLabelFont
        availableTitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        [libraryLabel, availableLabel, availableTitleLabel].forEach {
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
        
        libraryLabel.numberOfLines = 0
        libraryLabel.lineBreakMode = .byWordWrapping
        libraryLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        // Content
        availableTitleLabel.text = Localizations.Cell.Label.Available
        
        // Layout
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.setContentHuggingPriority(.required, for: .vertical)
        if #available(iOS 11, *) {
            stack.spacing = UIStackView.spacingUseSystem
            stack.isBaselineRelativeArrangement = true
        } else {
            stack.spacing = 4
        }
        [libraryLabel, availableLabel, availableTitleLabel].forEach { stack.addArrangedSubview($0) }
        
        [indicator, stack].forEach { contentView.addSubview($0) }
        indicator.snp.makeConstraints { (make) in
            make.width.equalTo(indicatorWidth)
            make.height.equalTo(indicatorWidth)
            make.leading.equalTo(contentView.snp.leading).offset(12)
            make.trailing.equalTo(stack.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
        stack.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualToSuperview().priority(UILayoutPriority.defaultLow.rawValue)
            make.bottom.greaterThanOrEqualToSuperview().priority(UILayoutPriority.defaultLow.rawValue)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(contentView.snp.trailing).offset(-8)
        }
    }
}
