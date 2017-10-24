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
    
    private lazy var separator = UIView()
    
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
    
    // MARK: - Populate
    private func updateTitle() {
        titleLabel.text = library?.name ?? Localizations.Common.Nodata
        subtitleLabel.text = library?.nameInAlternateLanguage ?? Localizations.Common.Nodata
    }
    
    private func populate() {
        availableSeatsLabel.text = libraryData?.available.readable ?? Localizations.Common.Nodata
        progressView.libraryData = libraryData
        artistLabel.text = "Photography by \(libraryData?.media?.artist.name ?? Localizations.Common.Nodata)"
    }
    
    // MARK: - Setup
    private func setup() {
        setupView()
        setupLayout()
        titleLabel.text = Localizations.Common.Nodata
        subtitleLabel.text = Localizations.Common.Nodata
        availableSeatsLabel.text = Localizations.Common.Nodata
        availableLabel.text = Localizations.Common.Available
        timestampLabel.text = "Updated at --"
        artistLabel.text = "Photography by --"
    }
    
    private func setupView() {
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 16
        
        titleStack.axis = .vertical
        titleStack.alignment = .fill
        titleStack.distribution = .fillProportionally
        titleStack.spacing = 4
        
        dataStack.axis = .horizontal
        dataStack.alignment = .lastBaseline
        dataStack.distribution = .equalSpacing
        dataStack.spacing = 8
        
        availableStack.axis = .vertical
        availableStack.alignment = .fill
        availableStack.distribution = .fillProportionally
        availableStack.spacing = 2
        
        infoStack.axis = .horizontal
        infoStack.alignment = .fill
        infoStack.distribution = .equalSpacing
        infoStack.spacing = 4
        
        titleLabel.font = UIFont.systemFont(ofSize: 33, weight: .bold)
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        availableSeatsLabel.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        availableLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        timestampLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        artistLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        subtitleLabel.textColor = .darkGray
        timestampLabel.textColor = .lightGray
        artistLabel.textColor = .lightGray
        separator.backgroundColor = #colorLiteral(red: 0.8392109871, green: 0.8391088247, blue: 0.8563356996, alpha: 1)
    }
    
    private func setupLayout() {
        [stack, separator].forEach { addSubview($0) }
        [titleStack, dataStack, infoStack].forEach { stack.addArrangedSubview($0) }
        [titleLabel, subtitleLabel].forEach { titleStack.addArrangedSubview($0) }
        [availableStack, progressView].forEach { dataStack.addArrangedSubview($0) }
        [availableSeatsLabel, availableLabel].forEach { availableStack.addArrangedSubview($0) }
        [timestampLabel, artistLabel].forEach { infoStack.addArrangedSubview($0) }
        
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(snp.topMargin)
            make.leading.equalTo(readableContentGuide).inset(8)
            make.trailing.equalTo(readableContentGuide).inset(8)
            make.bottom.equalTo(snp.bottomMargin)
        }
        progressView.snp.makeConstraints { (make) in
            make.width.equalTo(dataStack).multipliedBy(0.6)
        }
        separator.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.3)
        }
    }
}
