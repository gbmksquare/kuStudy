//
//  StudyAreaViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/06.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class StudyAreaViewController: UIViewController, Handoffable {
    // MARK: - Data
    private var libraryType: LibraryType!
    
    private var data: StudyArea! {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Initialization
    static func instantiate(with data: StudyArea, libraryType: LibraryType) -> StudyAreaViewController {
        let viewController = StudyAreaViewController()
        viewController.data = data
        viewController.libraryType = libraryType
        return viewController
    }
    
    // MARK: - View
    private lazy var refreshControl = UIRefreshControl()
    
    private lazy var shareBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(tap(share:)))
        item.accessibilityLabel = "share".localized()
        return item
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StudyAreaItemCell.self,
                                forCellWithReuseIdentifier: StudyAreaItemCell.reuseIdentifier)
        collectionView.register(StudyAreaHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: StudyAreaHeaderView.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startHandoff(with: NSUserActivity.studyArea(data, libraryType: libraryType))
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).invalidateLayout()
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateHandoff()
    }
    
    // MARK: - Setup
    private func setup() {
        title = data.name
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItems = [shareBarItem]
        
        refreshControl.addTarget(self,
                                 action: #selector(handle(refresh:)),
                                 for: .valueChanged)
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
    private func tap(share sender: UIBarButtonItem) {
        let summary = data.summary
        presentShareSheet(activityItems: [summary],
                          applicationActivities: nil,
                          barButtonItem: sender)
    }
    
    @objc
    private func handle(refresh sender: UIRefreshControl) {
        DataManager.shared.requestUpdate()
    }
    
    // MARK: - Action
    private func refreshData() {
        data = DataManager.shared.studyAreaData(for: data.identifier,
                                                libraryIdentifier: libraryType.identifier)
    }
    
    private func updateView() {
        refreshControl.endRefreshing()
        collectionView.reloadData()
    }
    
    // MARK: - Notification
    @objc
    private func handle(dataUpdated notification: Notification) {
        refreshData()
    }
}

// MARK: - Collection view
extension StudyAreaViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // MARK: Delegate flow layout
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            let width = collectionView.bounds.width
            let height: CGFloat
            let sizeCategory = traitCollection.preferredContentSizeCategory
            if sizeCategory == .accessibilityExtraLarge ||
                sizeCategory == .accessibilityExtraExtraLarge ||
                sizeCategory == .accessibilityExtraExtraExtraLarge {
                height = 240
            } else if sizeCategory == .small ||
                sizeCategory == .extraSmall {
                height = 140
            } else {
                height = 160
            }
            return CGSize(width: width, height: height)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.readableContentGuide.layoutFrame.width
        let height: CGFloat
        let sizeCategory = traitCollection.preferredContentSizeCategory
        if sizeCategory == .accessibilityExtraLarge ||
            sizeCategory == .accessibilityExtraExtraLarge ||
            sizeCategory == .accessibilityExtraExtraExtraLarge {
            height = 100
        } else if sizeCategory == .small ||
            sizeCategory == .extraSmall {
            height = 50
        } else {
            height = 60
        }
        return CGSize(width: width, height:  height)
    }
    
    // MARK: Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: StudyAreaHeaderView.reuseIdentifier,
                                                                       for: indexPath) as! StudyAreaHeaderView
            view.populate(with: data)
            return view
        } else {
            #if DEBUG
            fatalError()
            #else
            return UICollectionReusableView()
            #endif
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudyAreaItemCell.reuseIdentifier, for: indexPath) as! StudyAreaItemCell
        switch indexPath.item {
        case 0:
            cell.populate(title: "total".localizedFromKit(),
                          value: data.totalSeats,
                          systemImageName: "studentdesk")
        case 1:
            cell.populate(title: "laptop".localizedFromKit(),
                          boolean: data.laptopCapable,
                          systemImageName: "desktopcomputer")
        case 2:
            cell.populate(title: "accessible".localizedFromKit(),
                          value: data.accessibleSeats,
                          systemImageName: "hand.raised.slash")
        case 3:
            cell.populate(title: "useable".localizedFromKit(),
                          value: data.useableSeats,
                          systemImageName: "studentdesk")
        case 4:
            cell.populate(title: "occupied".localizedFromKit(),
                          value: data.occupiedSeats,
                          systemImageName: "studentdesk")
        case 5:
            cell.populate(title: "available".localizedFromKit(),
                          value: data.availableSeats,
                          systemImageName: "studentdesk")
        case 6:
            cell.populate(title: "repairing".localizedFromKit(),
                          value: data.repairingSeats,
                          systemImageName: "hammer.fill")
        case 7:
            cell.populate(title: "inallotable".localizedFromKit(),
                          value: data.inallotableSeats,
                          systemImageName: "xmark.rectangle.fill")
        case 8:
            cell.populate(title: "disabled".localizedFromKit(),
                          value: data.disabledSeats,
                          systemImageName: "xmark.rectangle.fill")
        default:
            break
        }
        return cell
    }
}
