//
//  MainViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 03/01/2020.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import os.log

class MainViewController: UIViewController, Handoffable {
    // MARK: - Data
    private var data = Summary() {
        didSet {
            organizeFetchedData()
        }
    }
    
    private var orderedData = [Library]() {
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
        collectionView.register(LibraryCell.self,
                                forCellWithReuseIdentifier: LibraryCell.reuseIdentifier)
        collectionView.register(MainHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MainHeaderView.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var settingsButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "gear"),
                               style: .plain,
                               target: self,
                               action: #selector(presentSettings))
        item.accessibilityLabel = "settings".localized()
        return item
    }()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startHandoff(with: NSUserActivity.summary(data))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateHandoff()
    }
    
    // MARK: - Setup
    private func setup() {
        title = "studyArea".localizedFromKit()
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItems = [settingsButton]
        
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
        guard let identifier = activity.userInfo?[NSUserActivity.Key.libraryIdentifier.name] as? String,
            let libraryType = LibraryType(rawValue: identifier) else {
                os_log(.error, log: .default, "Failed to restore user activity.")
                return
        }
        navigationController?.popToRootViewController(animated: false)
        presentLibraryView(with: libraryType)
    }
    
    // MARK: - User Interaction
    @objc
    private func presentSettings() {
        let settings = UINavigationController(rootViewController: SettingsViewController())
        present(settings, animated: true)
    }
    
    @objc
    private func handle(refresh sender: UIRefreshControl) {
        updateData()
    }
    
    // MARK: - Action
    private func updateData() {
        DataManager.shared.requestUpdate()
    }
    
    private func updateView() {
        refreshControl.endRefreshing()
        collectionView.reloadData()
    }
    
    private func organizeFetchedData() {
        let orderedLibraryIDs = Preference.shared.libraryOrder
        orderedData = orderedLibraryIDs.compactMap { identifier in
            data.libraries.first { identifier == $0.type.identifier }
        }
    }
    
    @discardableResult
    private func presentLibraryView(with libraryType: LibraryType) -> UIViewController {
        let viewController = LibraryViewController.instantiate(with: libraryType)
        showDetailViewController(UINavigationController(rootViewController: viewController), sender: self)
        return viewController
    }
    
    // MARK: - Notification
    @objc
    private func handle(dataUpdated notification: Notification) {
        data = DataManager.shared.summary()
    }
}

// MARK: - Collection view
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // MARK: Delegate flow layout
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let libraryType = orderedData[indexPath.item].type
        presentLibraryView(with: libraryType)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.readableContentGuide.layoutFrame.width
        return CGSize(width: width, height: 100)
    }
    
    // MARK: Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: MainHeaderView.reuseIdentifier,
                                                                       for: indexPath) as! MainHeaderView
            view.populate(with: data)
            return view
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let value = collectionView.readableContentGuide.layoutFrame.origin.x
        return UIEdgeInsets(top: 16, left: value, bottom: 0, right: value)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCell.reuseIdentifier, for: indexPath) as! LibraryCell
        let library = orderedData[indexPath.item]
        cell.populate(with: library)
        return cell
    }
}

// MARK: - Context menu
extension MainViewController {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch indexPath.section {
        case 0:
            let summary = orderedData[indexPath.item].summary
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
        default:
            return nil
        }
    }
}

// TODO: Implement drag & drop to reorder / Notified when order pref change
// TODO: Implement drag & drop to share content
