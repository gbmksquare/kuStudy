//
//  TitleDescriptionValueCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/07.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

class TitleSubtitleValueCell: UICollectionViewCell {
    // MARK: - View
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 2.scaled(for: .body)
        return stackView
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold).scaled(for: .callout)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold).scaled(for: .headline)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 26, weight: .medium).scaled(for: .body)
        return label
    }()
    
    // MARK: - State
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                containerView.backgroundColor = .quaternarySystemFill
            } else {
                containerView.backgroundColor = .secondarySystemGroupedBackground
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
        contentView.layer.cornerRadius = AppPreference.cornerRadius
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true
        
        contentView.isAccessibilityElement = true
        contentView.accessibilityTraits = UIAccessibilityTraits.staticText
        contentView.accessibilityValue = "중간고사까지 25일 남았습니다."
        [titleLabel, subtitleLabel, valueLabel].forEach {
            $0.isAccessibilityElement = false
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
        }
        
        if #available(iOS 13.4, *) {
            containerView.addInteraction(UIPointerInteraction(delegate: self))
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.margins.equalToSuperview().inset(8)
        }
        
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(valueLabel)
    }
    
    // MARK: - Popualte
    private func reset() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        valueLabel.text = nil
    }
    
    func populate(title: String, subtitle: String, value: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        valueLabel.text = value
    }
}

// MARK: - Pointer
@available(iOS 13.4, *)
extension TitleSubtitleValueCell: UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        return .init(effect: .lift(.init(view: self)))
    }
}
