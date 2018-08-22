//
//  LibraryViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import MXParallaxHeader
import DZNEmptyDataSet
import Crashlytics
import UserNotifications
import StoreKit
import DeviceKit

class LibraryViewController: UIViewController {
    private lazy var headerContentView = LibraryHeaderView()
    private var heroImageView: UIImageView!
    private var heroImageViewHeight: CGFloat?
    private lazy var gradient = CAGradientLayer()
    private lazy var tableView = UITableView()
    private lazy var footerContentView = LibraryFooterView()
    
    var library: LibraryType = LibraryType.centralSquare
    private var libraryData: LibraryData?
    private var dataState: DataSourceState = .fetching
    private var error: Error?
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        libraryData = kuStudy.libraryData(for: library)
        updateView()
        
        Answers.logContentView(withName: library.name, contentType: "Library", contentId: library.identifier, customAttributes: ["Device": UIDevice.current.model, "Version": UIDevice.current.systemVersion])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startHandoff()
        handleNavigationBar()
        
        // This line fixes edge gesture not working if view is loaded with 3D Touch
        // Don't move this line to `viewDidLoad`
        enableEdgeBackGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show rate on App Store
        #if !DEBUG
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        #endif
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeHeader()
        resizeFooter()
        resizeGradient()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateImageHeaderHeight()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endHandoff()
    }
}

// MARK: - Action
extension LibraryViewController {
    @available(*, deprecated: 1.0)
    private func updateData() {
        kuStudy.requestLibraryData(libraryId: library.identifier,
                                   onSuccess: { [weak self] (libraryData) in
                                    self?.libraryData = libraryData
                                    self?.updateView()
        }) { [weak self] (error) in
            self?.dataState = .error
            self?.error = error
            self?.updateView()
        }
    }
    
    private func updateView() {
        headerContentView.libraryData = libraryData
        tableView.reloadData()
    }
    
    @objc private func tapped(remind button: UIButton? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] (settings) in
            switch settings.authorizationStatus {
            case .authorized: self?.askRemindTimeInterval()
            case .denied: self?.handleNotificationAccessDenied()
            case .notDetermined:
                NotificationCoordinator.shared.requestAuthorization { (granted, error) in
                    DispatchQueue.main.async {
                        self?.tapped(remind: button)
                    }
                }
            }
        }
    }
    
    @objc private func tapped(action button: UIButton? = nil ) {
        
    }
    
    @objc private func handleUserDefaultsDidChange(_ notification: Notification) {
        updateView()
    }
    
    private func askRemindTimeInterval() {
        let library = self.library
        let alert = UIAlertController(title: nil, message: Localizations.Alert.Message.Notification.SetTimeInterval, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = headerContentView.remindButton
        alert.popoverPresentationController?.sourceRect = headerContentView.remindButton.bounds
        alert.popoverPresentationController?.permittedArrowDirections = .any
        #if DEBUG
        let debugOption = UIAlertAction(title: RemindInterval.now.name, style: .default) { (_) in
            NotificationCoordinator.shared.remind(library: library, fromNow: .now)
        }
        alert.addAction(debugOption)
        #endif
        let option1 = UIAlertAction(title: RemindInterval.hour2.name, style: .default) { (_) in
            NotificationCoordinator.shared.remind(library: library, fromNow: .hour2)
        }
        let option2 = UIAlertAction(title: RemindInterval.hour4.name, style: .default) { (_) in
            NotificationCoordinator.shared.remind(library: library, fromNow: .hour4)
        }
        let option3 = UIAlertAction(title: RemindInterval.hour6.name, style: .default) { (_) in
            NotificationCoordinator.shared.remind(library: library, fromNow: .hour6)
        }
        let cancel = UIAlertAction(title: Localizations.Alert.Action.Cancel, style: .cancel, handler: nil)
        [option1, option2, option3, cancel].forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
    
    private func handleNotificationAccessDenied() {
        let alert = UIAlertController(title: Localizations.Alert.Title.Notification.AccessDenied, message: Localizations.Alert.Message.Notification.AccessDenied, preferredStyle: .alert)
        alert.popoverPresentationController?.sourceView = headerContentView.remindButton
        let confirm = UIAlertAction(title: Localizations.Alert.Action.Confirm, style: .default) { [weak self] (_) in
            self?.tapped(remind: nil)
        }
        let openSettings = UIAlertAction(title: Localizations.Alert.Action.OpenSettings, style: .default) { (_) in
            guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
            let app = UIApplication.shared
            if app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(confirm)
        alert.addAction(openSettings)
        present(alert, animated: true, completion: nil)
    }
    
    private func enableEdgeBackGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - UI
extension LibraryViewController {
    private func resizeHeader() {
        if let header = tableView.tableHeaderView {
            let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = header.frame
            if frame.height != height {
                frame.size.height = height
                header.frame = frame
                tableView.tableHeaderView = header
            }
        }
    }
    
    private func resizeFooter() {
        if let footer = tableView.tableFooterView {
            let height = footer.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = footer.frame
            if frame.height != height {
                frame.size.height = height
                footer.frame = frame
                tableView.tableFooterView = footer
            }
        }
    }
    
    private func resizeGradient() {
        let size = CGSize(width: view.bounds.width, height: UIApplication.shared.statusBarFrame.height + 8)
        gradient.frame = CGRect(origin: .zero, size: size)
    }
    
    private func handleNavigationBar() {
        let scrollView = tableView as UIScrollView
        let offset = scrollView.contentOffset.y
        
        // Navigation bar
        if offset >= 0 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func handleScrollOffset() {
//        let scrollView = tableView as UIScrollView
//        let offset = scrollView.contentOffset.y
//        let headerHeight = tableView.parallaxHeader.height
//
//        if offset < 0 && offset > -44 {
//            scrollView.setContentOffset(CGPoint(x: 0, y: -headerHeight), animated: true)
//        } else {
//
//        }
    }
}

// MARK: - Notification
extension LibraryViewController {
    @objc private func handleShouldUpdateImage(_ notification: Notification) {
        UIView.transition(with: heroImageView,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            guard let library = self?.library else { return }
                            self?.heroImageView.image = MediaManager.shared.preferredMedia(for: library).image
            }, completion: nil)
    }
    
    @objc private func handleDataUpdated(_ notification: Notification) {
        if let summary = kuStudy.summaryData {
            if summary.libraries.count > 0 {
                libraryData = kuStudy.libraryData(for: library)
                updateView()
                return
            }
        }
        //        refreshView.endRefreshing()
        // Error
        dataState = .error
        error = kuStudy.errors?.first
        updateView()
    }
}

// MARK: - Gesture
extension LibraryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Handoff
extension LibraryViewController {
    private func startHandoff() {
        let activity = NSUserActivity(activityType: kuStudyHandoffLibrary)
        activity.title = library.name
        activity.addUserInfoEntries(from: ["libraryId": library.identifier])
        activity.becomeCurrent()
        userActivity = activity
    }
    
    private func endHandoff() {
        userActivity?.invalidate()
    }
}

// MARK: - Setup
extension LibraryViewController {
    private func setup() {
        title = library.name
        headerContentView.library = library
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleShouldUpdateImage(_:)), name: MediaManager.shouldUpdateImageNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdated(_:)), name: kuStudy.didUpdateDataNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDefaultsDidChange(_: )), name: UserDefaults.didChangeNotification, object: nil)
        
        // Mavigation
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        
        // Table header
        tableView.tableHeaderView = headerContentView
        
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIgnoresInvertColors = true
        tableView.parallaxHeader.view = imageView
        tableView.parallaxHeader.height = 200
        tableView.parallaxHeader.mode = .fill
        heroImageView = imageView
        updateImageHeaderHeight()
        
        // Table
        SectorCellType.allTypes.forEach {
            tableView.register($0.cellClass, forCellReuseIdentifier: $0.preferredReuseIdentifier)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        footerContentView.library = library
//        tableView.tableFooterView = footerContentView
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Header image
        let heroImage = MediaManager.shared.preferredMedia(for: library).image
        assert(heroImage != nil, "Hero image should not be nil.")
        heroImageView.image = heroImage
        
        // Graident
        let size = CGSize(width: view.bounds.width, height: UIApplication.shared.statusBarFrame.height + 8)
        let color = UIColor.black
        gradient.colors = [color.withAlphaComponent(0.6).cgColor,
                           color.withAlphaComponent(0.3).cgColor,
                           color.withAlphaComponent(0.1).cgColor,
                           color.withAlphaComponent(0).cgColor]
        gradient.frame = CGRect(origin: .zero, size: size)
        heroImageView.layer.addSublayer(gradient)
        
        // Action buttons
        headerContentView.remindButton.addTarget(self, action: #selector(tapped(remind:)), for: .touchUpInside)
        headerContentView.actionButton.addTarget(self, action: #selector(tapped(action:)), for: .touchUpInside)
    }
    
    private func updateImageHeaderHeight() {
        let height: CGFloat
        if traitCollection.verticalSizeClass == .compact {
            height = 120
        } else if traitCollection.userInterfaceIdiom == .phone {
            height = Device().isOneOf([.iPhoneX, .simulator(.iPhoneX)]) == true ? 180 : 160
        } else {
            height = 160
        }
        tableView.parallaxHeader.height = height
        heroImageViewHeight = height
    }
}

// MARK: - Table view
extension LibraryViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryData?.sectors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = libraryData?.sectors?[indexPath.row]
        let type = Preference.shared.sectorCellType
        switch type {
        case .classic:
            let cell = tableView.dequeueReusableCell(withIdentifier: type.preferredReuseIdentifier, for: indexPath) as! ClassicSectorCell
            cell.selectionStyle = .none
            cell.sectorData = data
            cell.accessibilityIdentifier = "Library Cell \(indexPath.row)"
            cell.layoutIfNeeded()
            return cell
        case .compact:
            let cell = tableView.dequeueReusableCell(withIdentifier: type.preferredReuseIdentifier, for: indexPath) as! CompactSectorCell
            cell.selectionStyle = .none
            cell.sectorData = data
            cell.accessibilityIdentifier = "Library Cell \(indexPath.row)"
            return cell
        case .veryCompact:
            let cell = tableView.dequeueReusableCell(withIdentifier: type.preferredReuseIdentifier, for: indexPath) as! VeryCompactSectorCell
            cell.selectionStyle = .none
            cell.sectorData = data
            cell.accessibilityIdentifier = "Library Cell \(indexPath.row)"
            return cell
        }
    }
    
    // Empty state
    func emptyDataSetDidTap(_ scrollView: UIScrollView!) {
        kuStudy.requestUpdateData()
        updateView()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = dataState == .fetching ? Localizations.Label.Loading : (error?.localizedDescription ?? Localizations.Label.Error)
        let attribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]
        return NSAttributedString(string: text, attributes: attribute)
    }
}

// MARK: - Scroll view
extension LibraryViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleNavigationBar()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollOffset()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        handleScrollOffset()
    }
}
