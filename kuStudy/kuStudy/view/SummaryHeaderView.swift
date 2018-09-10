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
    private lazy var gradient = CAGradientLayer()
    private lazy var stack = UIStackView()
    private lazy var dateLabel = UILabel()
    private lazy var summaryLabel = UILabel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.snp.updateConstraints { (make) in
            if traitCollection.preferredContentSizeCategory >= .accessibilityMedium {
                make.height.equalTo(180)
            } else {
                make.height.equalTo(100)
            }
        }
        collectionView.collectionViewLayout.invalidateLayout()
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
        summaryLabel.text = "Welcome, Lorem ipsum! :)\nCras mattis consectetur purus sit amet fermentum."
    }
    
    private func setupView() {
        gradient.colors = [UIColor.white.cgColor, UIColor(displayP3Red: 242/255, green: 242/255, blue: 241/255, alpha: 1).cgColor]
        gradient.locations = [0.2, 1.0]
        gradient.frame = bounds
        layer.addSublayer(gradient)
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = UIStackView.spacingUseSystem
        
        let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
        dateLabel.font = headlineMetrics.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .bold))
        dateLabel.textColor = .darkText
        
        let summaryMetrics = UIFontMetrics(forTextStyle: .body)
        summaryLabel.font = summaryMetrics.scaledFont(for: UIFont.systemFont(ofSize: 16, weight: .regular))
        summaryLabel.textColor = .black
        summaryLabel.numberOfLines = 0
        summaryLabel.lineBreakMode = .byWordWrapping
        
        [dateLabel, summaryLabel].forEach {
            $0.adjustsFontSizeToFitWidth = true
            $0.adjustsFontForContentSizeCategory = true
        }
        
        collectionView.clipsToBounds = false
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
        [stack, collectionView].forEach { addSubview($0) }
//        [dateLabel,summaryLabel].forEach { stack.addArrangedSubview($0) }
        [dateLabel].forEach { stack.addArrangedSubview($0) }
        
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(self).inset(12)
            make.leading.equalTo(readableContentGuide.snp.leading).inset(8)
            make.trailing.equalTo(readableContentGuide.snp.trailing).inset(8)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(stack.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(100)
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
        if traitCollection.preferredContentSizeCategory >= .accessibilityExtraExtraLarge {
            return CGSize(width: 300, height: collectionView.bounds.height)
        } else if traitCollection.preferredContentSizeCategory >= .accessibilityMedium {
            return CGSize(width: 220, height: collectionView.bounds.height)
        } else {
            return CGSize(width: 130, height: collectionView.bounds.height)
        }
    }
    
    // Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SummaryHeaderItemCell
        populate(cell: cell, at: indexPath)
        return cell
    }
    
    private func populate(cell: SummaryHeaderItemCell, at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let activeSemester = SemesterCalendarManager.shared.activeSemester {
                cell.titleLabel.text = Localizations.Label.EndOfSemester
                cell.valueLabel.text = activeSemester.semester.end.daysFromToday.readable
                cell.descriptionLabel.text = Localizations.Label.DaysLeft
            } else {
                cell.titleLabel.text = Localizations.Label.Vacation
                cell.valueLabel.text = "😎"
                cell.descriptionLabel.text = Localizations.Label.Hooray
            }
        case 1:
            cell.titleLabel.text = Localizations.Common.Total
            cell.valueLabel.text = summary?.occupied?.readable ?? Localizations.Common.NoData
            cell.descriptionLabel.text = Localizations.Common.Studying
        case 2:
            cell.titleLabel.text = Localizations.Common.LiberalArtCampus
            cell.valueLabel.text = summary?.liberalArtCampusData.occupied?.readable ?? Localizations.Common.NoData
            cell.descriptionLabel.text = Localizations.Common.Studying
        case 3:
            cell.titleLabel.text = Localizations.Common.ScienceCampus
            cell.valueLabel.text = summary?.scienceCampusData.occupied?.readable ?? Localizations.Common.NoData
            cell.descriptionLabel.text = Localizations.Common.Studying
        default: break
        }
        cell.updateAccessibleDescription()
    }
}
