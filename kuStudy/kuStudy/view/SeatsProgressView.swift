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
    var sectorData: SectorData? { didSet { populate() } }
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    // MARK: - View
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        occupiedStack.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            let metrics = UIFontMetrics(forTextStyle: .caption2)
            make.bottom.equalTo(progressView.snp.top).offset(metrics.scaledValue(for: -4))
        }
        progressView.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            let metrics = UIFontMetrics(forTextStyle: .caption2)
            make.height.equalTo(metrics.scaledValue(for: 8))
        }
    }
    
    // MARK: - Action
    func getColors() -> (barColor: UIColor, trackColor: UIColor) {
        return (progressView.barColor, progressView.trackColor)
    }
    
    func setColors(colors: (barColor: UIColor, trackColor: UIColor)) {
        progressView.barColor = colors.barColor
        progressView.trackColor = colors.trackColor
    }
    
    // MARK: - Populate
    private func populate() {
        if let data = libraryData {
            occupiedSeatsLabel.text  = data.occupied.readable
            totalSeatsLabel.text = data.total.readable
            progressView.trackColor = data.occupiedPercentageColor
            progressView.setProgress(data.occupiedPercentage, animated: false)
        } else if let data = sectorData {
            occupiedSeatsLabel.text  = data.occupied?.readable ?? Localizations.Common.NoData
            totalSeatsLabel.text = data.total?.readable ?? Localizations.Common.NoData
            progressView.trackColor = data.occupiedPercentageColor
            progressView.setProgress(data.occupiedPercentage, animated: false)
        } else {
            occupiedSeatsLabel.text  = Localizations.Common.NoData
            totalSeatsLabel.text = Localizations.Common.NoData
            progressView.trackColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.937254902, alpha: 1)
            progressView.setProgress(0, animated: false)
        }
    }
    
    // MARK: - Setup
    private func setup() {
        setupView()
        setupLayout()
        setupContent()
    }
    
    private func setupContent() {
        occupiedSeatsLabel.text = Localizations.Common.NoData
        occupiedLabel.text = Localizations.Common.Used
        totalSeatsLabel.text = Localizations.Common.NoData
        totalLabel.text = Localizations.Common.Total
        progressView.setProgress(0, animated: false)
    }
    
    private func setupView() {
        progressView.accessibilityIgnoresInvertColors = true
        
        [occupiedStack, totalStack].forEach {
            $0.axis = .vertical
            $0.distribution = .fillProportionally
            $0.spacing = 0
        }
        occupiedStack.alignment = .leading
        totalStack.alignment = .trailing
        
        [occupiedSeatsLabel, totalSeatsLabel].forEach {
            $0.textColor = .darkGray
            let bodyMetrics = UIFontMetrics(forTextStyle: .caption2)
            $0.font = bodyMetrics.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        }
        
        [occupiedLabel, totalLabel].forEach {
            $0.textColor = .darkGray
            let bodyMetrics = UIFontMetrics(forTextStyle: .caption2)
            $0.font = bodyMetrics.scaledFont(for: UIFont.systemFont(ofSize: 10, weight: .semibold))
        }
        
        [occupiedSeatsLabel, occupiedLabel, totalSeatsLabel, totalLabel].forEach {
            $0.adjustsFontForContentSizeCategory = true
            $0.adjustsFontSizeToFitWidth = true
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
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            let metrics = UIFontMetrics(forTextStyle: .caption2)
            make.bottom.equalTo(progressView.snp.top).offset(metrics.scaledValue(for: -4))
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
            let metrics = UIFontMetrics(forTextStyle: .caption2)
            make.height.equalTo(metrics.scaledValue(for: 8))
        }
    }
}
