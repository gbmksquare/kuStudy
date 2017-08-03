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

class LibraryViewController: UIViewController {
    @IBOutlet private weak var table: UITableView!
    @IBOutlet private weak var header: UIView!
    
    private var heroImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    private lazy var gradient = CAGradientLayer()
    
    @IBOutlet var dataLabels: [UILabel]!
    @IBOutlet var dataTitleLabels: [UILabel]!
    
    private var showNavigationAnimator: UIViewPropertyAnimator?
    private var hideNavigationAnimator: UIViewPropertyAnimator?
    
    override var hidesBottomBarWhenPushed: Bool {
        get { return navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    var libraryId: String! = Preference.shared.libraryOrder.first ?? "1"
    private var libraryData: LibraryData?
    
    private var dataState: DataSourceState = .fetching
    private var error: Error?
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateData()
        
        if let libraryType = LibraryType(rawValue: libraryId) {
            Answers.logContentView(withName: libraryType.name, contentType: "Library", contentId: libraryId, customAttributes: ["Device": UIDevice.current.model, "Version": UIDevice.current.systemVersion])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startHandoff()
        handleNavigationBar()
        
        // This line fixes edge gesture not working if view is loaded with 3D Touch
        // Don't move this line to `viewDidLoad`
        enableEdgeBackGesture()
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
        setupGradient()
        setupTableView()
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
    
    private func setupImageHeader() {
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
        gradient.colors = [UIColor.black.withAlphaComponent(0.45).cgColor, UIColor.black.withAlphaComponent(0).cgColor]
        gradient.frame = CGRect(origin: .zero, size: size)
        heroImageView.layer.addSublayer(gradient)
    }
    
    private func setupTableView() {
        table.tableFooterView = UIView()
    }
    
    private func setupContent() {
        let photo = PhotoProvider.sharedProvider.photo(libraryId)
        
        title = LibraryType(rawValue: libraryId)?.name
        titleLabel.text = LibraryType(rawValue: libraryId)?.name
        subtitleLabel.text = LibraryType(rawValue: libraryId)?.nameInAlternateLanguage
        heroImageView.image = photo.image
        
        dataTitleLabels.forEach {
            guard let tag = DataTag(rawValue: $0.tag) else { return }
            switch tag {
            case .total: $0.text = Localizations.Common.Total
            case .available: $0.text = Localizations.Common.Available
            case .used: $0.text = Localizations.Common.Used
            case .disabled: $0.text = Localizations.Common.Disabled
            case .printer: $0.text = Localizations.Common.Printer
            case .scanner: $0.text = Localizations.Common.Scanner
            case .ineligible: $0.text = Localizations.Common.Ineligible
            case .outOfOrder: $0.text = Localizations.Common.Outoforder
            }
        }
    }
}

// MARK: - Action
extension LibraryViewController {
    private func updateData() {
        guard let libraryId = self.libraryId else { return }
        kuStudy.requestLibraryData(libraryId: libraryId,
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
        if let libraryData = libraryData {
            dataLabels.forEach {
                guard let tag = DataTag(rawValue: $0.tag) else { return }
                switch tag {
                case .total: $0.text = libraryData.totalSeats.readable
                case .available: $0.text = libraryData.availableSeats.readable
                case .used: $0.text = libraryData.usedSeats.readable
                case .disabled: $0.text = libraryData.disabledOnlySeats.readable
                case .printer: $0.text = libraryData.printerCount.readable
                case .scanner: $0.text = libraryData.scannerCount.readable
                case .ineligible: $0.text = libraryData.ineligibleSeats.readable
                case .outOfOrder: $0.text = libraryData.outOfOrderSeats.readable
                }
            }
        }
        table.reloadData()
    }
}

// MARK: - Handoff
extension LibraryViewController {
    private func startHandoff() {
        guard let libraryId = self.libraryId, let name = LibraryType(rawValue: libraryId)?.name else { return }
        let activity = NSUserActivity(activityType: kuStudyHandoffLibrary)
        activity.title = name
        activity.addUserInfoEntries(from: ["libraryId": libraryId])
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
        return libraryData?.sectorCount ?? 0
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
        updateData()
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
        
        if offset > 0 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

// MARK: - Scroll view
extension LibraryViewController {
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            handleNavigationBar()
        }
}

// MARK: - Gesture
extension LibraryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
