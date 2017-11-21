//
//  SummaryHeaderView.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 11. 16..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import kuStudyKit

class SummaryHeaderView: UIView {
    private lazy var stack = UIStackView()
    
    private lazy var dateLabel = UILabel()
    private lazy var summaryLabel = UILabel()
    
    private lazy var separator = UIView()
    
    var summary: SummaryData? { didSet { populate() }}
    
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
    private func populate() {
        if let occupied = summary?.occupied,
            let laCampusUsedSeats = summary?.occupiedInLiberalArtCampus?.readable,
            let scCampusUsedSeats = summary?.occupiedInScienceCampus?.readable {
            summaryLabel.text = Localizations.Main.Studying(occupied.readable) + "\n" + Localizations.Main.StudyingCampus(laCampusUsedSeats, scCampusUsedSeats)
        }
    }
    
    // MARK: - Setup
    private func setup() {
        setupView()
        setupLayout()
        setupContent()
    }
    
    private func setupContent() {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        
        dateLabel.text = formatter.string(from: Date()).localizedUppercase
        summaryLabel.text = "\n\n"
    }
    
    private func setupView() {
        separator.backgroundColor = #colorLiteral(red: 0.8392109871, green: 0.8391088247, blue: 0.8563356996, alpha: 1)
        
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 8
        
        let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
        dateLabel.font = headlineMetrics.scaledFont(for: UIFont.systemFont(ofSize: 18, weight: .bold))
        dateLabel.textColor = #colorLiteral(red: 0.8392109871, green: 0.8391088247, blue: 0.8563356996, alpha: 1)

        summaryLabel.font = UIFont.preferredFont(forTextStyle: .body)
        summaryLabel.textColor = .black
        summaryLabel.numberOfLines = 0
        summaryLabel.lineBreakMode = .byWordWrapping
        
        [dateLabel, summaryLabel].forEach {
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
        }
    }
    
    private func setupLayout() {
        [stack, separator].forEach { addSubview($0) }
        [dateLabel,summaryLabel].forEach { stack.addArrangedSubview($0) }
        
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(self).inset(12)
            make.leading.equalTo(readableContentGuide.snp.leading).inset(8)
            make.trailing.equalTo(readableContentGuide.snp.trailing).inset(8)
        }
        separator.snp.makeConstraints { (make) in
            make.top.equalTo(stack.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.3)
        }
    }
}
