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
import SafariServices

class LibraryFooterView: UIView {
    private lazy var map = MKMapView()
    private lazy var stack = UIStackView()
    private lazy var appleMapButton = UIButton()
    private lazy var googleMapButton = UIButton()
    private lazy var openInSafariButton = UIButton()
    
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
            let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            map.setRegion(region, animated: true)
        }
    }
    
    // MARK: - Action
    @objc private func openAppleMaps() {
        // Apple Maps Universal Link Reference
        // https://developer.apple.com/library/content/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
        guard let library = library else { return }
        guard let url = URL(string: "http://maps.apple.com/?t=m&z=18&ll=\(library.coordinate.latitude),\(library.coordinate.longitude)") else { return }
        if UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func openGoogleMaps() {
        // Google Maps Universal Link Reference
        // https://developers.google.com/maps/documentation/urls/ios-urlscheme
        guard let library = library else { return }
        guard let url = URL(string: "https://www.google.com/maps/@\(library.coordinate.latitude),\(library.coordinate.longitude),18z") else { return }
        if UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func openInSafari() {
        guard let library = library else { return }
        guard let url = library.url else { return }
        let safari = SFSafariViewController(url: url)
        safari.preferredControlTintColor = UIColor.theme
        safari.dismissButtonStyle = .close
        UIApplication.shared.keyWindow?.topViewController()?.present(safari, animated: true, completion: nil)
    }
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = .lightBackground
        
        map.mapType = .standard
        map.isZoomEnabled = false
        map.isScrollEnabled = false
        map.isPitchEnabled = false
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
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 2
        stack.setContentHuggingPriority(.required, for: .horizontal)
        stack.setContentHuggingPriority(.required, for: .vertical)
        addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(map).inset(2)
            make.leading.equalTo(map.snp.trailing).offset(16)
            make.trailing.equalTo(readableContentGuide.snp.trailing)
        }
        
        let captionMetrics = UIFontMetrics(forTextStyle: .caption2)
        [appleMapButton, googleMapButton, openInSafariButton].forEach {
            $0.setTitleColor(.theme, for: .normal)
            $0.titleLabel?.font = captionMetrics.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .semibold))
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.titleLabel?.adjustsFontForContentSizeCategory = true
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
        
        appleMapButton.setTitle(Localizations.Library.Button.OpenInAppleMaps, for: .normal)
        appleMapButton.addTarget(self, action: #selector(openAppleMaps), for: .touchUpInside)
        stack.addArrangedSubview(appleMapButton)
        
        googleMapButton.setTitle(Localizations.Library.Button.OpenInGoogleMaps, for: .normal)
        googleMapButton.addTarget(self, action: #selector(openGoogleMaps), for: .touchUpInside)
        stack.addArrangedSubview(googleMapButton)
        
        openInSafariButton.setTitle(Localizations.Action.OpenLibraryInSafari, for: .normal)
        openInSafariButton.addTarget(self, action: #selector(openInSafari), for: .touchUpInside)
        stack.addArrangedSubview(openInSafariButton)
    }
}
