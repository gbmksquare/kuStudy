//
//  StudySectionCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/03/29.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class StudySectionCell: RoundCornerCell {
    // MARK: - View
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemFill
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true
        view.accessibilityIgnoresInvertColors = true
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 2.scaled(for: .body)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold).scaled(for: .headline)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return stackView
    }()
    
    private lazy var occupiedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular).scaled(for: .body)
        return label
    }()
    
    private lazy var availableLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular).scaled(for: .body)
        return label
    }()
    
    private lazy var progressView: GBMProgressView = {
        let progress = GBMProgressView(progressViewStyle: .bar)
        progress.trackTintColor = .systemGray4
        progress.progress = 0
        progress.lineWidth = 8
        progress.accessibilityIgnoresInvertColors = true
        return progress
    }()
    
    private lazy var supplementaryTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return stackView
    }()
    
    private lazy var occupiedTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold).scaled(for: .footnote)
        return label
    }()
    
    private lazy var availableTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold).scaled(for: .footnote)
        return label
    }()
    
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
        contentView.accessibilityTraits = UIAccessibilityTraits.staticText
        
        occupiedTitleLabel.text = "occupied".localizedFromKit().localizedUppercase
        availableTitleLabel.text = "available".localizedFromKit().localizedUppercase
        
        [titleLabel, occupiedLabel, availableLabel, occupiedTitleLabel, availableTitleLabel].forEach {
            $0.isAccessibilityElement = false
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
        }
    }
    
    private func setupLayout() {
        containerView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.width.equalTo(14)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(indicatorView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(textStackView)
        mainStackView.addArrangedSubview(progressView)
        mainStackView.addArrangedSubview(supplementaryTextStackView)
        
        textStackView.addArrangedSubview(occupiedLabel)
        textStackView.addArrangedSubview(availableLabel)
        supplementaryTextStackView.addArrangedSubview(occupiedTitleLabel)
        supplementaryTextStackView.addArrangedSubview(availableTitleLabel)
        
        progressView.snp.makeConstraints { (make) in
            make.height.equalTo(8)
        }
    }
    
    // MARK: - Popualte
    private func reset() {
        titleLabel.text = nil
        occupiedLabel.text = nil
        titleLabel.text = nil
        progressView.progress = 0
        contentView.accessibilityLabel = nil
    }
    
    func populate(with studyArea: StudyArea) {
        indicatorView.backgroundColor = studyArea.occupiedPercentage.color
        titleLabel.text = studyArea.name
        occupiedLabel.text = studyArea.occupiedSeats.readable
        availableLabel.text = studyArea.availableSeats.readable
        progressView.progress = Float(studyArea.occupiedPercentage)
        progressView.progressTintColor = studyArea.occupiedPercentage.color
        contentView.accessibilityLabel = "\(studyArea.name) \("available".localized()) \(studyArea.availableSeats) \("occupied".localized()) \(studyArea.occupiedSeats)"
    }
}
