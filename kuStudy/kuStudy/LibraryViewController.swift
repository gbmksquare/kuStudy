//
//  LibraryViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 05/01/2020.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import StoreKit
import os.log

class LibraryViewController: UIViewController, Handoffable {
    // MARK: - Data
    private var libraryType: LibraryType!
    
    private var data: Library! {
        didSet {
            updateView()
        }
    }
    
    // MARK: - View
    private lazy var refreshControl = UIRefreshControl()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StudySectionCell.self,
                                forCellWithReuseIdentifier: StudySectionCell.reuseIdentifier)
        collectionView.register(LibraryMapCell.self,
                                forCellWithReuseIdentifier: LibraryMapCell.reuseIdentifier)
        collectionView.register(LibraryHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: LibraryHeaderView.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Initialization
    static func instantiate(with libraryType: LibraryType) -> LibraryViewController {
        let viewController = LibraryViewController()
        viewController.libraryType = libraryType
        return viewController
    }
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startHandoff(with: NSUserActivity.library(data))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if !DEBUG
        SKStoreReviewController.requestReview()
        #endif
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateHandoff()
    }
    
    // MARK: - Setup
    private func setup() {
        title = "Library"
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        refreshControl.addTarget(self, action: #selector(handle(refresh:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        // Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(dataUpdated:)),
                                               name: DataManager.didUpdateNotification,
                                               object: DataManager.shared)
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - State restoration
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        super.restoreUserActivityState(activity)
        // TODO: Implement
    }
    
    // MARK: - User interaction
    @objc
    private func handle(refresh sender: UIRefreshControl) {
        updateData()
    }
    
    // MARK: - Action
    private func updateData() {
        data = DataManager.shared.libraryData(for: libraryType.identifier)
    }
    
    private func updateView() {
        refreshControl.endRefreshing()
        title = data.name
        collectionView.reloadData()
    }
    
    private func openInAppleMaps(library: LibraryType) {
        // Apple Maps Universal Link Reference
        // https://developer.apple.com/library/content/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
        let coordinate = libraryType.coordinate
        guard let url = URL(string: "http://maps.apple.com/?t=m&z=18&ll=\(coordinate.latitude),\(coordinate.longitude)") else { return }
        if UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            os_log(.error, log: .default, "Failed to open Apple Maps")
        }
    }
    
    private func openInGoogleMaps(_ libraryType: LibraryType) {
        // Google Maps Universal Link Reference
        // https://developers.google.com/maps/documentation/urls/ios-urlscheme
        let coordinate = libraryType.coordinate
        guard let url = URL(string: "https://www.google.com/maps/@\(coordinate.latitude),\(coordinate.longitude),18z") else { return }
        if UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            os_log(.error, log: .default, "Failed to open Google Maps")
        }
    }
    
    @discardableResult
    private func presentStudyAreaView(with studyArea: StudyArea, libraryType: LibraryType) -> UIViewController {
        let viewController = StudyAreaViewController.instantiate(with: studyArea, libraryType: libraryType)
        showDetailViewController(viewController, sender: self)
        return viewController
    }
    
    // MARK: - Notification
    @objc
    private func handle(dataUpdated notification: Notification) {
        updateView()
    }
}

// MARK: - Collection view
extension LibraryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // MARK: Delegate flow layout
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let data = self.data.studyAreas[indexPath.item]
            presentStudyAreaView(with: data, libraryType: libraryType)
        } else if indexPath.section == 1 {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            let width = collectionView.bounds.width
            let height: CGFloat
            let sizeCategory = traitCollection.preferredContentSizeCategory
            if sizeCategory == .accessibilityExtraLarge ||
                sizeCategory == .accessibilityExtraExtraLarge ||
                sizeCategory == .accessibilityExtraExtraExtraLarge {
                height = 336
            } else if sizeCategory == .small ||
                sizeCategory == .extraSmall {
                height = 236
            } else {
                height = 256
            }
            return CGSize(width: width, height: height)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let width = collectionView.readableContentGuide.layoutFrame.width
            return CGSize(width: width, height: 100)
        case 1:
            let width = collectionView.readableContentGuide.layoutFrame.width
            return CGSize(width: width, height: 200)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 0, right: 8)
    }
    
    // MARK: Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: LibraryHeaderView.reuseIdentifier,
                                                                       for: indexPath) as! LibraryHeaderView
            view.populate(with: data)
            return view
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return data.studyAreas.count
        case 1: return 1
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudySectionCell.reuseIdentifier, for: indexPath) as! StudySectionCell
            let studyArea = data.studyAreas[indexPath.item]
            cell.populate(with: studyArea)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryMapCell.reuseIdentifier, for: indexPath) as! LibraryMapCell
            cell.populate(with: data.type)
            return cell
        default:
            fatalError()
        }
    }
}

// MARK: - Context menu
extension LibraryViewController {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch indexPath.section {
        case 0:
            let summary = data.studyAreas[indexPath.item].summary
            let copy = UIAction.copy(string: summary)
            let share = UIAction.share(string: summary,
                                       presentOn: self,
                                       sourceView: collectionView.cellForItem(at: indexPath))
            let menu = UIMenu(title: "", children: [copy, share])
            return UIContextMenuConfiguration(identifier: nil,
                                       previewProvider: nil)
            { (elements) -> UIMenu? in
                return menu
            }
        case 1:
            let appleMap = UIAction.maps(title: "openAppleMaps".localized()) { [weak self] (_) in
                guard let data = self?.data else { return }
                self?.openInAppleMaps(library: data.type)
            }
            let googleMap = UIAction.maps(title: "openGoogleMaps".localized()) { [weak self] (_) in
                guard let data = self?.data else { return }
                self?.openInGoogleMaps(data.type)
            }
            let menu = UIMenu(title: "", children: [appleMap, googleMap])
            return UIContextMenuConfiguration(identifier: nil,
                                       previewProvider: nil)
            { (elements) -> UIMenu? in
                return menu
            }
        default:
            return nil
        }
    }
}
