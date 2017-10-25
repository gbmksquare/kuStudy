//
//  SeatsProgressView.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 24..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import LinearProgressView

class SeatsProgressView: UIView {
    private lazy var occupiedStack = UIStackView()
    private lazy var occupiedSeatsLabel = UILabel()
    private lazy var occupiedLabel = UILabel()
    
    private lazy var totalStack = UIStackView()
    private lazy var totalSeatsLabel = UILabel()
    private lazy var totalLabel = UILabel()
    
    private lazy var progressView = LinearProgressView()
    
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
        progressView.trackColor = libraryData?.occupiedPercentageColor ?? #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.937254902, alpha: 1)
        progressView.setProgress(libraryData?.occupiedPercentage ?? 0, animated: false)
    }
    
    // MARK: - Setup
    private func setup() {
        setupView()
        setupLayout()
        
        occupiedSeatsLabel.text = Localizations.Common.NoData
        occupiedLabel.text = Localizations.Common.Used
        totalSeatsLabel.text = Localizations.Common.NoData
        totalLabel.text = Localizations.Common.Total
        progressView.setProgress(0, animated: false)
    }
    
    private func setupView() {
        [occupiedStack, totalStack].forEach {
            $0.axis = .vertical
            $0.distribution = .fillProportionally
            $0.spacing = 0
        }
        occupiedStack.alignment = .leading
        totalStack.alignment = .trailing
        
        [occupiedSeatsLabel, totalSeatsLabel].forEach {
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        }
        
        [occupiedLabel, totalLabel].forEach {
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        }
        
        progressView.minimumValue = 0
        progressView.maximumValue = 1
        progressView.isCornersRounded = true
        progressView.barInset = 0
        progressView.barColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.937254902, alpha: 1)
        progressView.trackColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.937254902, alpha: 1)
    }
    
    private func setupLayout() {
        [occupiedStack, totalStack, progressView].forEach { addSubview($0) }
        [occupiedSeatsLabel, occupiedLabel].forEach { occupiedStack.addArrangedSubview($0) }
        [totalSeatsLabel, totalLabel].forEach { totalStack.addArrangedSubview($0) }
        
        occupiedStack.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalTo(progressView.snp.top).offset(-4)
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
            make.height.equalTo(8)
        }
    }
}
