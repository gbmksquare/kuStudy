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
    private lazy var dateLabel = UILabel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        collectionView.reloadData()
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
    }
    
    private func setupView() {
        separator.backgroundColor = .separator
        
        let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
        dateLabel.font = headlineMetrics.scaledFont(for: UIFont.systemFont(ofSize: 16, weight: .semibold))
        dateLabel.textColor = .textDark
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.adjustsFontForContentSizeCategory = true
        
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(SummaryHeaderItemCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupLayout() {
        [dateLabel, collectionView, separator].forEach { addSubview($0) }
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(12)
            make.leading.equalTo(readableContentGuide.snp.leading).inset(8)
            make.trailing.equalTo(readableContentGuide.snp.trailing).inset(8)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(separator.snp.top).offset(-16)
            make.height.equalTo(100)
        }
        separator.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.3)
        }
    }
}

// MARK: - Collection view
extension SummaryHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.bounds.height)
    }
    
    // Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SummaryHeaderItemCell
        populate(cell: cell, at: indexPath)
        return cell
    }
    
    private func populate(cell: SummaryHeaderItemCell, at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = Localizations.Common.Total
            cell.valueLabel.text = summary?.occupied?.readable ?? Localizations.Common.NoData
            cell.descriptionLabel.text = Localizations.Common.Studying
            cell.setBackgroundColor(summary?.occupiedPercentageColor ?? .placeholder)
        case 1:
            cell.titleLabel.text = Localizations.Common.LiberalArtCampus
            cell.valueLabel.text = summary?.liberalArtCampusData.occupied?.readable ?? Localizations.Common.NoData
            cell.descriptionLabel.text = Localizations.Common.Studying
            cell.setBackgroundColor(summary?.liberalArtCampusData.occupiedPercentageColor ?? .placeholder)
        case 2:
            cell.titleLabel.text = Localizations.Common.ScienceCampus
            cell.valueLabel.text = summary?.scienceCampusData.occupied?.readable ?? Localizations.Common.NoData
            cell.descriptionLabel.text = Localizations.Common.Studying
            cell.setBackgroundColor(summary?.scienceCampusData.occupiedPercentageColor ?? .placeholder)
        default: break
        }
    }
}
