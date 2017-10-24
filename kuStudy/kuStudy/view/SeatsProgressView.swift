//
//  SeatsProgressView.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 24..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class SeatsProgressView: UIView {
    private lazy var occupiedStack = UIStackView()
    private lazy var occupiedSeatsLabel = UILabel()
    private lazy var occupiedLabel = UILabel()
    
    private lazy var totalStack = UIStackView()
    private lazy var totalSeatsLabel = UILabel()
    private lazy var totalLabel = UILabel()
    
    private lazy var progressView = UIProgressView()
    
    var libraryData: LibraryData? { didSet { populate() } }
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    // MARK: - Populate
    private func populate() {
        occupiedSeatsLabel.text  = libraryData?.occupied.readable ?? Localizations.Common.NoData
        totalSeatsLabel.text = libraryData?.total.readable ?? Localizations.Common.NoData
        progressView.progress = libraryData?.occupiedPercentage ?? 0
        progressView.tintColor = libraryData?.occupiedPercentageColor
    }
    
    // MARK: - Setup
    private func setup() {
        setupView()
        setupLayout()
        
        occupiedSeatsLabel.text = Localizations.Common.NoData
        occupiedLabel.text = Localizations.Common.Used
        totalSeatsLabel.text = Localizations.Common.NoData
        totalLabel.text = Localizations.Common.Total
        progressView.progress = 0
    }
    
    private func setupView() {
        [occupiedStack, totalStack].forEach {
            $0.axis = .vertical
            $0.distribution = .fillProportionally
            $0.spacing = 1
        }
        occupiedStack.alignment = .leading
        totalStack.alignment = .trailing
        
        [occupiedSeatsLabel, totalSeatsLabel].forEach {
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        
        [occupiedLabel, totalLabel].forEach {
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        }
    }
    
    private func setupLayout() {
        [occupiedStack, totalStack, progressView].forEach { addSubview($0) }
        [occupiedSeatsLabel, occupiedLabel].forEach { occupiedStack.addArrangedSubview($0) }
        [totalSeatsLabel, totalLabel].forEach { totalStack.addArrangedSubview($0) }
        
        occupiedStack.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalTo(progressView.snp.top).offset(-8)
        }
        
        totalStack.snp.makeConstraints { (make) in
            make.top.equalTo(occupiedStack)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(occupiedStack)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(4)
        }
    }
}
