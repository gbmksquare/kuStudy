//
//  StudyAreaHeaderView.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/06.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class StudyAreaHeaderView: UICollectionReusableView {
    // MARK: - View
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()
    
    private lazy var progressView = BigNumberProgressView()
    
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
        
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.leading.equalTo(readableContentGuide.snp.leading)
            make.trailing.equalTo(readableContentGuide.snp.trailing)
            make.top.equalTo(0)
            make.bottom.equalTo(-16)
        }
        
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(progressView)
    }
    
    // MARK: - Populate
    func populate(with data: StudyArea) {
        progressView.populate(progress: data.occupiedPercentage,
                              progressValue: data.occupiedSeats,
                              remainingValue: data.availableSeats)
    }
    
    private func reset() {
        
    }
}
