//
//  LibraryFooterView.swift
//  kuStudy
//
//  Created by BumMo Koo on 22/06/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import MapKit

class LibraryFooterView: UIView {
    private lazy var map = MKMapView()
    
    // MARK: - View
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    // MARK: - Populate
    private func populate() {
        
    }
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.9333333333, alpha: 1)

        map.layer.cornerRadius = 9
        map.layer.masksToBounds = true
        addSubview(map)
        map.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(readableContentGuide.snp.leading).inset(8)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
    }
}
