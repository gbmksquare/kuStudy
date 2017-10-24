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

class LibraryViewController: UIViewController {
    @IBOutlet private weak var table: UITableView!
    @IBOutlet private weak var header: UIView!
    
    private var heroImageView: UIImageView!
    private var headerContentView = LibraryHeaderView()
    
    private lazy var gradient = CAGradientLayer()
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var remindButton: UIButton!
    
    override var hidesBottomBarWhenPushed: Bool {
        get { return navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endHandoff()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeHeader()
        resizeGradient()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setImageHeaderHeight()
        table.reloadData()
    }
}

// MARK: - Setup
extension LibraryViewController {
    private func setup() {
        setupNavigation()
        setupImageHeader()
        setupView()
        setupGradient()
        setupTableView()
        setupNotification()
        setupContent()
    }
    
    private func setupNavigation() {
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func enableEdgeBackGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupView() {
        [mapButton, remindButton].forEach {
            $0?.clipsToBounds = true
            $0?.layer.cornerRadius = 9
        }
        mapButton.setTitle(Localizations.Library.Button.Map, for: .normal)
        remindButton.setTitle(Localizations.Library.Button.Remind, for: .normal)
    }
    
    private func setupImageHeader() {
        table.tableHeaderView = headerContentView
        
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        table.parallaxHeader.view = imageView
        table.parallaxHeader.height = 200
        table.parallaxHeader.mode = .fill
        heroImageView = imageView
        setImageHeaderHeight()
        
        if #available(iOS 11.0, *) {
            imageView.accessibilityIgnoresInvertColors = true
        }
    }
    
    private func setImageHeaderHeight() {
        if traitCollection.verticalSizeClass == .compact {
            table.parallaxHeader.height = 120
        } else if traitCollection.userInterfaceIdiom == .phone {
            table.parallaxHeader.height = 200
        } else {
            table.parallaxHeader.height = 280
        }
    }
    
    private func setupGradient() {
        let size = CGSize(width: view.bounds.width, height: UIApplication.shared.statusBarFrame.height + 8)
        let color = UIColor.black
        gradient.colors = [color.withAlphaComponent(0.6).cgColor,
                           color.withAlphaComponent(0.3).cgColor,
                           color.withAlphaComponent(0.1).cgColor,
                           color.withAlphaComponent(0).cgColor]
        gradient.frame = CGRect(origin: .zero, size: size)
        heroImageView.layer.addSublayer(gradient)
    }
    
    private func setupTableView() {
        table.tableFooterView = UIView()
        table.showsVerticalScrollIndicator = false
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleShouldUpdateImage(_:)), name: MediaManager.shouldUpdateImageNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdated(_:)), name: kuStudy.didUpdateDataNotification, object: nil)
    }
    
    private func setupContent() {
        title = library.name
        headerContentView.library = library
        
        // Image
        heroImageView.image = MediaManager.shared.media(for: library)?.image
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
                            self?.heroImageView.image = MediaManager.shared.media(for: library)?.image
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
        // Error
        dataState = .error
        error = kuStudy.errors?.first
        updateView()
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
        table.reloadData()
    }
    
    @IBAction fileprivate func tapped(map button: UIButton) {
        // Apple Maps Universal Link Reference
        // https://developer.apple.com/library/content/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
        //
        // Google Maps Universal Link Reference
        // https://developers.google.com/maps/documentation/urls/ios-urlscheme
        //
        let urlString = Preference.shared.preferredMap == .apple
            ? "http://maps.apple.com/?t=m&z=18&ll=\(library.coordinate.latitude),\(library.coordinate.longitude)"
            : "https://www.google.com/maps/@\(library.coordinate.latitude),\(library.coordinate.longitude),18z"
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction fileprivate func tapped(remind button: UIButton? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] (settings) in
            switch settings.authorizationStatus {
            case .authorized: self?.askRemindTimeInterval()
            case .denied: self?.handleNotificationAccessDenied()
            case .notDetermined:
                NotificationCoordinator.shared.requestAuthorization { (granted, error) in
                    DispatchQueue.main.async {
                        self?.tapped(remind: nil)
                    }
                }
            }
        }
    }
    
    private func askRemindTimeInterval() {
        let library = self.library
        let alert = UIAlertController(title: nil, message: Localizations.Alert.Message.Notification.SetTimeInterval, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = remindButton
        alert.popoverPresentationController?.sourceRect = remindButton.bounds
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
        alert.popoverPresentationController?.sourceView = remindButton
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
        let sector = libraryData?.sectors?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "readingRoomCell", for: indexPath) as! ReadingRoomTableViewCell
        if let sector = sector {
            cell.populate(sector: sector)
        }
        cell.updateInterface(for: traitCollection)
        return cell
    }
    
    // Empty state
    func emptyDataSetDidTap(_ scrollView: UIScrollView!) {
        kuStudy.requestUpdateData()
        updateView()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = dataState == .fetching ? Localizations.Table.Label.Loading : (error?.localizedDescription ?? Localizations.Table.Label.Error)
        let attribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]
        return NSAttributedString(string: text, attributes: attribute)
    }
}

// MARK: - UI
extension LibraryViewController {
    private func resizeHeader() {
        if let header = table.tableHeaderView {
            let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = header.frame
            if frame.height != height {
                frame.size.height = height
                header.frame = frame
                table.tableHeaderView = header
            }
        }
    }
    
    private func resizeGradient() {
        let size = CGSize(width: view.bounds.width, height: UIApplication.shared.statusBarFrame.height + 8)
        gradient.frame = CGRect(origin: .zero, size: size)
    }
    
    private func handleNavigationBar() {
        let scrollView = table as UIScrollView
        let offset = scrollView.contentOffset.y
        
        if offset >= 0 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func handleScrollOffset() {
        let scrollView = table as UIScrollView
        let offset = scrollView.contentOffset.y
        let headerHeight = table.parallaxHeader.height
        
        if offset < 0 && offset > -44 {
            scrollView.setContentOffset(CGPoint(x: 0, y: -headerHeight), animated: true)
        } else {
            
        }
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

// MARK: - Gesture
extension LibraryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
