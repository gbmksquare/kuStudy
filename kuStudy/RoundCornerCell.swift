//
//  RoundCornerCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/12.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

class RoundCornerCell: UICollectionViewCell {
    // MARK: - View
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - State
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = .quaternarySystemFill
            } else {
                backgroundColor = .secondarySystemGroupedBackground
            }
        }
    }
    
    @available(iOS 13.4, *)
    var pointerEffect: UIPointerEffect {
        return .lift(UITargetedPreview(view: self))
    }
    
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
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = .clear
        layer.cornerRadius = AppPreference.cornerRadius
        layer.masksToBounds = true
        
        contentView.backgroundColor = .secondarySystemGroupedBackground
        let marginValue = AppPreference.cornerRadius
        contentView.layoutMargins = UIEdgeInsets(top: marginValue,
                                                 left: marginValue,
                                                 bottom: marginValue,
                                                 right: marginValue)
        
        if #available(iOS 13.4, *) {
            addInteraction(UIPointerInteraction(delegate: self))
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.margins)
        }
    }
}

// MARK: - Pointer
@available(iOS 13.4, *)
extension RoundCornerCell: UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        return UIPointerStyle(effect: pointerEffect)
    }
}
