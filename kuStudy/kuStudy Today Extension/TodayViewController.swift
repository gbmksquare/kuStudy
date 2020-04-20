//
//  TodayViewController.swift
//  kuStudy Today Extension
//
//  Created by BumMo Koo on 2017. 8. 4..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import NotificationCenter
import kuStudyKit
import SnapKit

class TodayViewController: UIViewController {
    // MARK: - View
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TitleSubtitleValueProgressCell.self,
                                forCellWithReuseIdentifier: TitleSubtitleValueProgressCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var statusView = StatusView()
    
    // Data
    private var data = Summary() {
        didSet {
            organizeData()
        }
    }
    
    private var orderedData = [Library]() {
        didSet {
            updateView()
        }
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
    }
    
    // MARK: - Setup
    private func setup() {
        Preference.shared.setup()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        view.backgroundColor = .clear
        
        // MARK: - Notification
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
        
        view.addSubview(statusView)
        statusView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.layoutMarginsGuide.snp.edges)
        }
    }
    
    // MARK: - Action
    private func updateView() {
        collectionView.reloadData()
        
        if data.libraries.count > 0 {
            statusView.state = .success
        } else {
            statusView.state = .error(nil)
        }
    }
    
    private func updateData() {
        DataManager.shared.requestUpdate()
    }
    
    private func organizeData() {
        let orderedLibraryIDs = Preference.shared.libraryOrder
        orderedData = orderedLibraryIDs.compactMap { identifier in
            data.libraries.first { identifier == $0.type.identifier }
        }
    }
    
    private func openMainApp(for library: LibraryType) {
        let url = URL(string: "kustudy://?libraryId=\(library.identifier)")!
        extensionContext?.open(url, completionHandler: nil)
    }
    
    // MARK: - Notification action
    @objc
    private func handle(dataUpdated notification: Notification) {
        data = DataManager.shared.summary()
    }
}

// MARK: - Widget
extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        updateData()
        completionHandler(.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if case .expanded = activeDisplayMode {
            preferredContentSize = collectionView.contentSize != .zero ? collectionView.contentSize : CGSize(width: maxSize.width, height: 215)
        } else {
            preferredContentSize = extensionContext?.widgetMaximumSize(for: .compact) ?? maxSize
        }
    }
}

// MARK: - Collection view
extension TodayViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let library = orderedData[indexPath.item]
        openMainApp(for: library.type)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margins = view.layoutMargins
        return UIEdgeInsets(top: margins.top,
                            left: margins.left,
                            bottom: margins.bottom,
                            right: margins.right)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margins = view.layoutMargins
        let width = (collectionView.bounds.width - margins.left - margins.right - 8 * 2) / 3
        let height = (extensionContext?.widgetMaximumSize(for: .compact).height ?? 110) - margins.top - margins.bottom
        return CGSize(width: width, height: height)
    }
    
    // Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleSubtitleValueProgressCell.reuseIdentifier, for: indexPath) as! TitleSubtitleValueProgressCell
        let library = orderedData[indexPath.item]
        cell.populate(title:  "available".localizedFromKit().localizedUppercase,
                      subtitle: library.name,
                      value: library.availableSeats.readable,
                      progress: library.occupiedPercentage)
        return cell
    }
}
