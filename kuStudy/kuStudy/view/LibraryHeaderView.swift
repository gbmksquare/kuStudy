//
//  LibraryHeaderView.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 24..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryHeaderView: UIView {
    private lazy var stack = UIStackView()
    
    private lazy var titleStack =  UIStackView()
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    
    private lazy var dataStack = UIStackView()
    
    private lazy var availableStack = UIStackView()
    private lazy var availableSeatsLabel = UILabel()
    private lazy var availableLabel = UILabel()
    
    private lazy var progressView = SeatsProgressView()
    
    private lazy var infoStack = UIStackView()
    private lazy var timestampLabel = UILabel()
    private lazy var artistLabel = UILabel()
    
    private lazy var infoSeparator = UIView()
    
    private lazy var buttonStack = UIStackView()
    lazy var mapButton = UIButton()
    lazy var remindButton = UIButton()
    lazy var actionButton = UIButton()
    
    private lazy var buttonSeparator = UIView()
    
    var library: LibraryType? { didSet { updateTitle() } }
    var libraryData: LibraryData? { didSet { populate() } }
    
    // MARK: - View
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.preferredContentSizeCategory >=  .extraExtraExtraLarge {
            setDataStackVertical()
            setupInfoStackVertical()
        } else {
            setDataStackHorizontal()
            setInfoStackHorizontal()
        }
    }
    
    // MARK: - Populate
    private func updateTitle() {
        titleLabel.text = library?.name ?? Localizations.Common.NoData
        subtitleLabel.text = library?.nameInAlternateLanguage ?? Localizations.Common.NoData
    }
    
    private func populate() {
        availableSeatsLabel.text = libraryData?.available.readable ?? Localizations.Common.NoData
        progressView.libraryData = libraryData
        timestampLabel.text = Localizations.Library.UpdatedAt(kuStudy.lastUpdatedAt?.readable ?? Localizations.Common.NoData)
        artistLabel.text = libraryData?.media?.attribution ?? ""
    }
    
    // MARK: - Setup
    private func setup() {
        setupView()
        setupLayout()
        setupContent()
    }
    
    private func setupContent() {
        titleLabel.text = Localizations.Common.NoData
        subtitleLabel.text = Localizations.Common.NoData
        availableSeatsLabel.text = Localizations.Common.NoData
        availableLabel.text = Localizations.Common.Available
        timestampLabel.text = Localizations.Common.NoData
        artistLabel.text = Localizations.Common.NoData
        mapButton.setTitle(Localizations.Library.Button.Map, for: .normal)
        remindButton.setTitle(Localizations.Library.Button.Remind, for: .normal)
        let image = #imageLiteral(resourceName: "702-share").withRenderingMode(.alwaysTemplate)
        actionButton.setImage(image, for: .normal)
        actionButton.tintColor = UIColor.theme
    }
    
    private func setupView() {
        backgroundColor = .white
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 12
        
        titleStack.axis = .vertical
        titleStack.alignment = .fill
        titleStack.distribution = .fillProportionally
        titleStack.spacing = 2
        
        setDataStackHorizontal()
        
        availableStack.axis = .vertical
        availableStack.alignment = .fill
        availableStack.distribution = .fillProportionally
        availableStack.spacing = 0
        
        setInfoStackHorizontal()
        
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.distribution = .fill
        buttonStack.spacing = 8
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
        
        let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
        let subheadlineMetrics = UIFontMetrics(forTextStyle: .subheadline)
        let bodyMetrics = UIFontMetrics(forTextStyle: .body)
        let captionMetrics = UIFontMetrics(forTextStyle: .caption2)
        
        titleLabel.font = headlineMetrics.scaledFont(for: UIFont.systemFont(ofSize: 28, weight: .bold))
        subtitleLabel.font = subheadlineMetrics.scaledFont(for: UIFont.systemFont(ofSize: 18, weight: .semibold))
        availableSeatsLabel.font = bodyMetrics.scaledFont(for: UIFont.systemFont(ofSize: 36, weight: .regular))
        availableLabel.font = bodyMetrics.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .bold))
        timestampLabel.font = captionMetrics.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .semibold))
        artistLabel.font = captionMetrics.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .semibold))
        
        [titleLabel, subtitleLabel, availableLabel, availableSeatsLabel, timestampLabel, artistLabel].forEach {
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
        }
        
        subtitleLabel.textColor = .darkText
        availableLabel.textColor = .lightGray
        timestampLabel.textColor = .darkText
        artistLabel.textColor = .darkText
        infoSeparator.backgroundColor = .separator
        buttonSeparator.backgroundColor = .separator
        
        [mapButton, remindButton, actionButton].forEach {
            $0.setTitleColor(UIColor.theme, for: .normal)
            $0.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.9333333333, alpha: 1)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 9
        }
    }
    
    private func setupLayout() {
        [stack, infoSeparator].forEach { addSubview($0) }
        // !!!: Disabled buttons for now
//        [stack, infoSeparator, buttonStack, buttonSeparator].forEach { addSubview($0) }
        [titleStack, dataStack, infoStack].forEach { stack.addArrangedSubview($0) }
        [titleLabel, subtitleLabel].forEach { titleStack.addArrangedSubview($0) }
        [availableStack, progressView].forEach { dataStack.addArrangedSubview($0) }
        [availableSeatsLabel, availableLabel].forEach { availableStack.addArrangedSubview($0) }
        [timestampLabel, artistLabel].forEach { infoStack.addArrangedSubview($0) }
        [mapButton, remindButton, actionButton].forEach { buttonStack.addArrangedSubview($0) }
        
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(self).inset(12)
            make.leading.equalTo(readableContentGuide.snp.leading).inset(8)
            make.trailing.equalTo(readableContentGuide.snp.trailing).inset(8)
        }
        infoSeparator.snp.makeConstraints { (make) in
            make.top.equalTo(stack.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
//            make.bottom.equalTo(buttonStack.snp.top).offset(-8)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.3)
        }
//        buttonStack.snp.makeConstraints { (make) in
//            make.leading.equalTo(readableContentGuide).inset(8)
//            make.trailing.equalTo(readableContentGuide).inset(8)
//            make.height.equalTo(44)
//        }
//        mapButton.snp.makeConstraints { (make) in
//            make.width.equalTo(remindButton)
//        }
//        actionButton.snp.makeConstraints { (make) in
//            make.width.equalTo(actionButton.snp.height)
//        }
//        buttonSeparator.snp.makeConstraints { (make) in
//            make.top.equalTo(buttonStack.snp.bottom).offset(8)
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.height.equalTo(0.3)
//        }
    }
}

extension LibraryHeaderView {
    private func setDataStackHorizontal() {
        dataStack.axis = .horizontal
        dataStack.alignment = .lastBaseline
        dataStack.distribution = .fillEqually
        dataStack.spacing = UIStackView.spacingUseDefault
    }
    
    private func setDataStackVertical() {
        dataStack.axis = .vertical
        dataStack.alignment = .fill
        dataStack.distribution = .fillProportionally
        dataStack.spacing = UIStackView.spacingUseDefault
    }
    
    private func setInfoStackHorizontal() {
        infoStack.axis = .horizontal
        infoStack.alignment = .center
        infoStack.distribution = .equalSpacing
        infoStack.spacing = UIStackView.spacingUseDefault
    }
    
    private func setupInfoStackVertical() {
        infoStack.axis = .vertical
        infoStack.alignment = .leading
        infoStack.distribution = .equalSpacing
        infoStack.spacing = UIStackView.spacingUseDefault
    }
}
