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
    
    var library: LibraryType? {
        didSet { populate() }
    }
    
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
        if let coordinate = library?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 300, 300)
            map.setRegion(region, animated: true)
        }
    }
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.9333333333, alpha: 1)
        
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = false
        map.isPitchEnabled = true
        map.isRotateEnabled = false
        map.showsScale = false
        map.showsCompass = false
        map.showsTraffic = false
        map.showsBuildings = true
        map.showsUserLocation = false
        map.showsPointsOfInterest = true
        map.layer.borderWidth = 0.5
        map.layer.borderColor = UIColor.separator.cgColor
        map.layer.cornerRadius = 9
        map.layer.masksToBounds = true
        addSubview(map)
        map.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(readableContentGuide.snp.leading).inset(8)
            make.width.equalTo(160)
            make.height.equalTo(120)
        }
    }
}
