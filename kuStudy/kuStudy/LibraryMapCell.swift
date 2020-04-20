//
//  LibraryMapCell.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/03/29.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import MapKit
import kuStudyKit

class LibraryMapCell: RoundCornerCell {
    // MARK: - View
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = false
        map.isPitchEnabled = true
        map.isRotateEnabled = true
        map.showsScale = false
        map.showsCompass = true
        map.showsTraffic = false
        map.showsBuildings = true
        map.showsUserLocation = false
        return map
    }()
    
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
        contentView.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Popualte
    private func reset() {
        mapView.annotations.forEach { [weak self] in
            self?.mapView.removeAnnotation($0)
        }
    }
    
    func populate(with libraryType: LibraryType) {
//        let region = MKCoordinateRegion(center: libraryType.coordinate,
//                                        latitudinalMeters: 200,
//                                        longitudinalMeters: 200)
//        mapView.setRegion(region, animated: true)
        
        let camera = MKMapCamera(lookingAtCenter: libraryType.coordinate,
                                 fromDistance: 15,
                                 pitch: 135,
                                 heading: 0)
        camera.altitude = 0.0035
        mapView.setCamera(camera, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = libraryType.name
        annotation.coordinate = libraryType.coordinate
        mapView.addAnnotation(annotation)
    }
}
