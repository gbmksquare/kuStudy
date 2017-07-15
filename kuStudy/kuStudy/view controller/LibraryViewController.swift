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
    @IBOutlet fileprivate weak var table: UITableView!
    @IBOutlet fileprivate weak var header: UIView!
    
    fileprivate var heroImageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel: UILabel!
    
    fileprivate lazy var gradient = CAGradientLayer()
    
    @IBOutlet var dataLabels: [UILabel]!
    @IBOutlet var dataTitleLabels: [UILabel]!
    
    fileprivate var showNavigationAnimator: UIViewPropertyAnimator?
    fileprivate var hideNavigationAnimator: UIViewPropertyAnimator?
    
    override var hidesBottomBarWhenPushed: Bool {
        get { return navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    var libraryId: String! = Preference.shared.libraryOrder.first ?? "1"
    fileprivate var libraryData: LibraryData?
    
    fileprivate var dataState: DataSourceState = .fetching
    fileprivate var error: Error?
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideNavigation(animated: false)
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
}

// MARK: - Setup
extension LibraryViewController {
    fileprivate func setup() {
        automaticallyAdjustsScrollViewInsets = false
        setupNavigation()
        setupImageHeader()
        setupGradient()
        setupTableView()
        setupContent()
    }
    
    private func setupNavigation() {
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupImageHeader() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        table.parallaxHeader.view = imageView
        table.parallaxHeader.height = 200
        table.parallaxHeader.mode = .topFill
        heroImageView = imageView
    }
    
    private func setupGradient() {
        guard let navigationController = navigationController else { return }
        let size = CGSize(width: view.bounds.width, height: UIApplication.shared.statusBarFrame.height + navigationController.navigationBar.bounds.height)
        gradient.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear]
        gradient.frame = CGRect(origin: .zero, size: size)
        heroImageView.layer.addSublayer(gradient)
    }
    
    private func setupTableView() {
        table.tableFooterView = UIView()
        
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func setupContent() {
        //        libraryNameLabel.text = LibraryType(rawValue: libraryId)?.name
        //        availablePlaceholderLabel.text  = "kuStudy.Available".localized()
        //        totalPlaceholderLabel.text = "kuStudy.Total".localized()
        //        usedPlaceholderLabel.text = "kuStudy.Used".localized()
        
        //        availableLabel.text = "kuStudy.NoData".localized()
        //        totalLabel.text = "kuStudy.NoData".localized()
        //        usedLabel.text = "kuStudy.NoData".localized()
        
        //        photographerLabel.text = ""
        let photo = PhotoProvider.sharedProvider.photo(libraryId)
        //        headerImageView.image = photo.image
        //        headerBlurImageView.image = photo.image
        //        headerBlurImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
        //        photographerLabel.text = photo.photographer.attributionString
        
        titleLabel.text = LibraryType(rawValue: libraryId)?.name
        subtitleLabel.text = LibraryType(rawValue: libraryId)?.name
        heroImageView.image = photo.image
    }
}

// MARK: - Action
extension LibraryViewController {
    fileprivate func updateData() {
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
    
    fileprivate func updateView() {
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
    fileprivate func startHandoff() {
        guard let libraryId = self.libraryId, let name = LibraryType(rawValue: libraryId)?.name else { return }
        let activity = NSUserActivity(activityType: kuStudyHandoffLibrary)
        activity.title = name
        activity.addUserInfoEntries(from: ["libraryId": libraryId])
        activity.becomeCurrent()
        userActivity = activity
    }
    
    fileprivate func endHandoff() {
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
        return cell
    }
    
    // Empty state
    func emptyDataSetDidTap(_ scrollView: UIScrollView!) {
        updateData()
        updateView()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = dataState == .fetching ? "kuStudy.Status.Downloading".localized() : (error?.localizedDescription ?? "kuStudy.Status.Error".localized())
        let attribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)]
        return NSAttributedString(string: text, attributes: attribute)
    }
}

// MARK: - UI
extension LibraryViewController {
    fileprivate var navigationBackground: UIView? {
        return navigationController?.navigationBar.subviews.first
    }
    
    fileprivate func showNavigation(animated: Bool = true) {
        guard navigationBackground?.alpha != 1 else { return }
        navigationController?.isNavigationBarHidden = false
        if animated == true {
            guard showNavigationAnimator == nil else { return }
            hideNavigationAnimator?.stopAnimation(true)
            let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear, animations: { [weak self] in
                self?.navigationBackground?.alpha = 1
                //                self?.navigationController?.isNavigationBarHidden = false
            })
            animator.addCompletion({ [weak self] (_) in
                //                self?.navigationController?.isNavigationBarHidden = false
                self?.showNavigationAnimator = nil
                self?.hideNavigationAnimator = nil
            })
            showNavigationAnimator = animator
            animator.startAnimation()
        } else {
            navigationBackground?.alpha = 1
            //            navigationController?.isNavigationBarHidden = false
        }
    }
    
    fileprivate func hideNavigation(animated: Bool = true) {
        guard navigationBackground?.alpha != 0 else { return }
        if animated == true {
            guard hideNavigationAnimator == nil else { return }
            showNavigationAnimator?.stopAnimation(true)
            let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear, animations: { [weak self] in
                self?.navigationBackground?.alpha = 0
                //                self?.navigationController?.isNavigationBarHidden = true
            })
            animator.addCompletion({ [weak self] (_) in
                //                self?.navigationController?.isNavigationBarHidden = true
                self?.showNavigationAnimator = nil
                self?.hideNavigationAnimator = nil
            })
            hideNavigationAnimator = animator
            animator.startAnimation()
        } else {
            navigationBackground?.alpha = 0
            navigationController?.isNavigationBarHidden = true
        }
    }
    
    fileprivate func resizeHeader() {
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
    
    fileprivate func resizeGradient() {
        guard let navigationController = navigationController else { return }
        let size = CGSize(width: view.bounds.width, height: UIApplication.shared.statusBarFrame.height + navigationController.navigationBar.bounds.height)
        gradient.frame = CGRect(origin: .zero, size: size)
    }
}

// MARK: - Scroll view
extension LibraryViewController {
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.y
            if offset <= 0 {
                hideNavigation()
                title = nil
            } else {
                showNavigation()
                title = LibraryType(rawValue: libraryId)?.name
            }
        }
}

// MARK: - Gesture
extension LibraryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
