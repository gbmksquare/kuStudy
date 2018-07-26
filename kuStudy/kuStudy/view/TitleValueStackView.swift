//
//  TitleValueStackView.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 7. 26..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import UIKit

class TitleValueStackView: UIStackView {
    lazy var titleLabel = UILabel()
    lazy var valueLabel = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        axis = .vertical
        alignment = .leading
        distribution = .fill
        spacing = UIStackView.spacingUseDefault
        
        let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
        let bodyMetrics = UIFontMetrics(forTextStyle: .body)
        
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = headlineMetrics.scaledFont(for: UIFont.systemFont(ofSize: 13, weight: .regular))
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        addArrangedSubview(titleLabel)
        
        valueLabel.textColor = .black
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.adjustsFontForContentSizeCategory = true
        valueLabel.font = bodyMetrics.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .regular))
        valueLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        addArrangedSubview(valueLabel)
    }
}
