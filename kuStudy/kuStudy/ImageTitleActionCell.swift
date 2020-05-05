//
//  ImageTitleActionCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/07.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

class ImageTitleActionCell: RoundCornerCell {
    // MARK: - View
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4.scaled(for: .body)
        return stackView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = .appPrimary
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold).scaled(for: .body)
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - State
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = .quaternarySystemFill
            } else {
                backgroundColor = .secondarySystemGroupedBackground
            }
        }
    }
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    // MARK: - Setup
    private func setup() {
        contentView.isAccessibilityElement = true
        contentView.accessibilityTraits = UIAccessibilityTraits.button
        contentView.accessibilityLabel = titleLabel.accessibilityLabel
        
        [titleLabel].forEach {
            $0.isAccessibilityElement = false
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
        }
    }
    
    private func setupLayout() {
        
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.center.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(titleLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(24.scaled(for: .body))
            make.height.equalTo(imageView.snp.width)
        }
    }
    
    // MARK: - Popualte
    private func reset() {
        imageView.image = nil
        titleLabel.text = nil
    }
    
    func populate(title: String, image: UIImage?) {
        titleLabel.text = title
        imageView.image = image
    }
}
