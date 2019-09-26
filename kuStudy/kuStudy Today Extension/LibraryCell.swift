//
//  LibraryCell.swift
//  kuStudy Today Extension
//
//  Created by BumMo Koo on 2017. 8. 4..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryCell: UITableViewCell {
    private lazy var indicator = UIView()
    private lazy var libraryLabel = UILabel()
    private lazy var availableLabel = UILabel()
    private lazy var availableTitleLabel = UILabel()
    
    var data: LibraryData? {
        didSet { populate() }
    }
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
    
    // MARK: - View
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    // MARK: - Populate
    func populate() {
        guard let data = data,
            let library = data.libraryType else {
            reset()
            return
        }
        indicator.backgroundColor = data.availablePercentageColor
        libraryLabel.text = library.name

        let metrics = UIFontMetrics(forTextStyle: .body)
        let captionFont = metrics.scaledFont(for: UIFont.systemFont(ofSize: 10, weight: .medium))
        let availableString = NSMutableAttributedString()
        availableString.append(NSAttributedString(string: "\(Localizations.Cell.Label.Available)  ",
            attributes: [
                .foregroundColor: UIColor.tertiaryLabel,
                .font: captionFont
        ]))
        availableString.append(NSAttributedString(string: data.available.readable,
            attributes: [
                .foregroundColor: UIColor.label
        ]))
        availableLabel.attributedText = availableString
    }
    
    func reset() {
        indicator.backgroundColor = .lightGray
        libraryLabel.text = nil
        availableLabel.text = nil
    }
    
    // MARK: - Setup
    private func setup() {
        let metrics = UIFontMetrics(forTextStyle: .body)
        let titleFont = metrics.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .medium))
        let valueFont = metrics.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .regular))
        let spacing = metrics.scaledValue(for: 8)
        
        backgroundColor = .clear
        
        // Stack
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = spacing
        contentView.addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leadingMargin.equalToSuperview()
            make.trailingMargin.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // Label
        libraryLabel.font = titleFont
        libraryLabel.numberOfLines = 0
        libraryLabel.lineBreakMode = .byWordWrapping
        availableLabel.font = valueFont
        availableLabel.setContentHuggingPriority(.required, for: .horizontal)
        [libraryLabel, availableLabel].forEach {
            $0.textColor = .label
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
        }
        
        // Indicator
        let indicatorWidth: CGFloat = 10
        indicator.backgroundColor = .systemGray5
        indicator.layer.borderColor = UIColor.quaternarySystemFill.cgColor
        indicator.layer.borderWidth = 1
        indicator.layer.cornerRadius = indicatorWidth / 2
        indicator.snp.makeConstraints { (make) in
            make.width.equalTo(indicatorWidth)
            make.height.equalTo(indicator.snp.width)
        }
        
        [libraryLabel, availableLabel, indicator].forEach { stack.addArrangedSubview($0) }
    }
}
