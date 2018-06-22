//
//  LinkButton.swift
//  kuStudy
//
//  Created by BumMo Koo on 22/06/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import UIKit

class LinkButton: UIButton {
    override func tintColorDidChange() {
        super.tintColorDidChange()
        setTitleColor(tintColor, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        semanticContentAttribute  = .forceRightToLeft
        // https://stackoverflow.com/questions/17800288/autolayout-intrinsic-size-of-uibutton-does-not-include-title-insets
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
        titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        setImage(#imageLiteral(resourceName: "link"), for: .normal)
    }
}
