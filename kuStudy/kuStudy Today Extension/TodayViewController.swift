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
    // MARK: - Constants
    static let leadingAlignmentInset: CGFloat = 20
    static let trailingAlignmentInset: CGFloat = -60
    
    private lazy var tableView = UITableView(frame: .zero)
    private lazy var summaryView = UIView()
    private lazy var statusView = StatusView()
    
    // Data
    private var summary: SummaryData? {
        didSet { updateView() }
    }
    
    var orderedLibraryIds: [String]?
    
    // Preference
    private let numberOfCellPerLine: CGFloat = 1
    private let lineSpacing: CGFloat = 4
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateData()
    }
    
    // MARK: - Setup
    private func setup() {
        //        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        showStatus()
        view.backgroundColor = .clear
        setupTable()
        
        // Preference
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        defaults.register(defaults: ["todayExtensionOrder": LibraryType.allTypes().map({ $0.rawValue }),
                                     "todayExtensionHidden": []])
        defaults.synchronize()
        orderedLibraryIds = defaults.array(forKey: "todayExtensionOrder") as? [String]
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdated(_:)), name: kuStudy.didUpdateDataNotification, object: nil)
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LibraryCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.cellLayoutMarginsFollowReadableWidth = true
//        tableView.separatorInset = UIEdgeInsets(top: 0,
//                                                left: TodayViewController.leadingAlignmentInset,
//                                                bottom: 0,
//                                                right: TodayViewController.trailingAlignmentInset)
        
        // Layout
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: - Action
extension TodayViewController {
    private func updateView() {
        tableView.reloadData()
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
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        //        [summaryView, collectionView].forEach { view.addSubview($0) }
        //        [collectionView].forEach { view.addSubview($0) }
//        [tableView].forEach { view.addSubview($0) }
        //        summaryView.snp.makeConstraints { (make) in
        //            make.top.equalTo(view.snp.top)
        //            make.leading.equalTo(view.snp.leading)
        //            make.trailing.equalTo(view.snp.trailing)
        //            make.bottom.equalTo(collectionView.snp.top)
        //        }
//        tableView.snp.makeConstraints { (make) in
//            make.leading.equalTo(view.snp.leading)
//            make.trailing.equalTo(view.snp.trailing)
//            make.bottom.equalTo(view.snp.bottom)
//
//            make.top.equalTo(view.snp.top)
//        }
        tableView.isHidden = false
    }
    
    private func hideInformation() {
        extensionContext?.widgetLargestAvailableDisplayMode = .compact
        summaryView.removeFromSuperview()
//        tableView.removeFromSuperview()
        tableView.isHidden = true
    }
    
    // MARK: - Main application
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
}

// MARK: - Widget
extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(.noData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if case .expanded = activeDisplayMode, let count = orderedLibraryIds?.count {
            let lines = ceil(CGFloat(count) / numberOfCellPerLine)
            //extensionContext!.widgetMaximumSize(for: .compact).height
            let height = 44 * lines + lineSpacing * (lines - 1)
            preferredContentSize = CGSize(width: maxSize.width, height: height)
        } else {
            preferredContentSize = extensionContext!.widgetMaximumSize(for: .compact)
        }
    }
}

// MARK: - Table
extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let libraryId = summary?.libraries[indexPath.row].libraryType?.identifier else { return }
        openMainApp(libraryId: libraryId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  44
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.isHidden == true {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isHidden == true {
            return 0
        }
        let count = orderedLibraryIds?.count ?? 0
        extensionContext?.widgetLargestAvailableDisplayMode = count <= Int(numberOfCellPerLine) ? .compact : .expanded
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LibraryCell
        if let libraryId = orderedLibraryIds?[indexPath.row], let data = summary?.libraries.first(where: { return $0.libraryType?.rawValue == libraryId }) {
            cell.data = data
        } else {
//            assertionFailure()
        }
        return cell
    }
}
