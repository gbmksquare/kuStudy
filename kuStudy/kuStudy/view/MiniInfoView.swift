//
//  MinInfoView.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 26..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit

class MiniInfoView: UIView {
    private lazy var stack = UIStackView()
    lazy var imageView = UIImageView()
    
    private lazy var labelStack = UIStackView()
    lazy var titleLabel = UILabel()
    lazy var subtitleLabel = UILabel()
    
    // MARK: - Initializaiton
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        setupView()
        setupLayout()
        setupContent()
    }
    
    private func setupContent() {
        imageView.image = nil
        titleLabel.text = Localizations.Common.NoData
        subtitleLabel.text = Localizations.Common.NoData
    }
    
    private func setupView() {
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 6
        
        labelStack.axis = .vertical
        labelStack.distribution = .fillProportionally
        labelStack.alignment = .leading
        labelStack.spacing = 2
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        
        titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = .darkGray
        subtitleLabel.textColor = .darkGray
    }
    
    private func setupLayout() {
        addSubview(stack)
        [imageView, labelStack].forEach { stack.addArrangedSubview($0) }
        [titleLabel, subtitleLabel].forEach { labelStack.addArrangedSubview($0) }
        
        stack.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(imageView.snp.height)
            make.height.equalTo(24)
        }
    }
}
