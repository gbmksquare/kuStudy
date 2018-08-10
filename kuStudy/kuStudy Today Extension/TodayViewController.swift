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
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var summaryView = UIView()
    private lazy var statusView = StatusView()
    
    // Data
    private var summary: SummaryData? {
        didSet { updateView() }
    }
    
    var orderedLibraryIds: [String]?
    
    // Preference
    private let numberOfCellPerLine: CGFloat = 2
    private let lineSpacing: CGFloat = 10
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateData()
    }
    
    // MARK: - Setup
    private func setup() {
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        showStatus()
        
        view.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(LibraryCell.self, forCellWithReuseIdentifier: "cell")
        
        // Preference
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        defaults.register(defaults: ["todayExtensionOrder": LibraryType.allTypes().map({ $0.rawValue }),
                                     "todayExtensionHidden": []])
        defaults.synchronize()
        orderedLibraryIds = defaults.array(forKey: "todayExtensionOrder") as? [String]
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdated(_:)), name: kuStudy.didUpdateDataNotification, object: nil)
    }
}

// MARK: - Action
extension TodayViewController {
    private func updateView() {
        collectionView.reloadData()
    }
    
    private func updateData() {
        kuStudy.startFecthingData()
    }
    
    // Data
    @objc private func handleDataUpdated(_ notification: Notification) {
        if let summary = kuStudy.summaryData, summary.libraries.count > 0 {
            self.summary = summary
            hideStatus()
            showInformation()
            return
        }
        // Error
        self.summary = nil
        showStatus()
        statusView.setErrorState()
        hideInformation()
    }
    
    //
    func openMainApp(libraryId: String? = nil) {
        let url: URL
        if let libraryId = libraryId {
            url = URL(string: "kustudy://?libraryId=\(libraryId)")!
        } else {
            url = URL(string: "kustudy://")!
        }
        extensionContext?.open(url, completionHandler: { (completed) in
            
        })
    }
    
    // View
    private func showStatus() {
        view.addSubview(statusView)
        statusView.snp.remakeConstraints { (make) in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
        }
        statusView.setLoadingState()
    }
    
    private func hideStatus() {
        statusView.removeFromSuperview()
    }
    
    private func showInformation() {
//        [summaryView, collectionView].forEach { view.addSubview($0) }
        [collectionView].forEach { view.addSubview($0) }
//        summaryView.snp.makeConstraints { (make) in
//            make.top.equalTo(view.snp.top)
//            make.leading.equalTo(view.snp.leading)
//            make.trailing.equalTo(view.snp.trailing)
//            make.bottom.equalTo(collectionView.snp.top)
//        }
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
            
            make.top.equalTo(view.snp.top)
        }
    }
    
    private func hideInformation() {
        summaryView.removeFromSuperview()
        collectionView.removeFromSuperview()
    }
}

// MARK: - Collection view
extension TodayViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let libraryId = summary?.libraries[indexPath.row].libraryType?.identifier else { return }
        openMainApp(libraryId: libraryId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / numberOfCellPerLine
        let height = extensionContext!.widgetMaximumSize(for: .compact).height
        return CGSize(width: width, height: height)
    }
    
    // Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return summary?.libraries.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LibraryCell
//        cell.data = summary?.libraries[indexPath.row]
        if let libraryId = orderedLibraryIds?[indexPath.row], let data = summary?.libraries.first(where: { return $0.libraryType?.rawValue == libraryId }) {
            cell.data = data
        } else {
            assertionFailure()
        }
        return cell
    }
}

// MARK: - Widget
extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(.noData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if case .expanded = activeDisplayMode, let count = summary?.libraries.count {
            let lines = ceil(CGFloat(count) / numberOfCellPerLine)
            let height = extensionContext!.widgetMaximumSize(for: .compact).height * lines + lineSpacing * (lines - 1)
            preferredContentSize = CGSize(width: maxSize.width, height: height)
        } else {
            preferredContentSize = extensionContext!.widgetMaximumSize(for: .compact)
        }
    }
}
