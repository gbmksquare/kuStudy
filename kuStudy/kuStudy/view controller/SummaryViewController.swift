//
//  SummaryViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import MXParallaxHeader
import DZNEmptyDataSet
import Localize_Swift
import Crashlytics

enum DataSourceState {
    case fetching, error
}

class SummaryViewController: UIViewController {
    @IBOutlet fileprivate weak var table: UITableView!
    @IBOutlet fileprivate weak var header: UIView!
    
    @IBOutlet fileprivate weak var heroImageView: UIImageView!
    
    fileprivate lazy var gradient = CAGradientLayer()
    
    fileprivate var showNavigationAnimator: UIViewPropertyAnimator?
    fileprivate var hideNavigationAnimator: UIViewPropertyAnimator?
    
    fileprivate var summaryData = SummaryData()
    fileprivate var dataState: DataSourceState = .fetching
    fileprivate var error: Error?
    
    fileprivate var orderedLibraryIds: [String]!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateData()
        
        Answers.logContentView(withName: "Summary", contentType: "Summary", contentId: "0", customAttributes: ["Device": UIDevice.current.model, "Version": UIDevice.current.systemVersion])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startHandoff()
        updateHeaderImage()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if (splitViewController?.childViewControllers.last?.childViewControllers.first is LibraryViewController) == false {
                if let indexPath = table.indexPathForSelectedRow {
                    table.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNavigation(animated: false)
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
extension SummaryViewController {
    fileprivate func setup() {
        setupImageHeader()
        setupGradient()
        setupTableView()
        setupContent()
        listenForUserDefaultsDidChange()
        registerPeekAndPop()
    }
    
    private func setupImageHeader() {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
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
        var inset = table.contentInset
        inset.bottom += tabBarController?.tabBar.bounds.height ?? 0
        table.contentInset = inset
        table.tableFooterView = UIView()
        
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func setupContent() {
//        usedPlaceholderLabel.text = "kuStudy.Main.Studying".localized()
//        laCampusUsedPlaceholderLabel.text = "kuStudy.LiberalArtCampus".localized() + ":"
//        scCampusUsedPlaceholderLabel.text = "kuStudy.ScienceCampus".localized() + ":"
//
//        usedLabel.text = "kuStudy.NoData".localized()
//        laCampusUsedLabel.text = "kuStudy.NoData".localized() + "kuStudy.Main.Studying".localized()
//        scCampusUsedLabel.text = "kuStudy.NoData".localized() + "kuStudy.Main.Studying".localized()
    }
    
    private func listenForUserDefaultsDidChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDefaultsDidChange(_: )), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    private func registerPeekAndPop() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
}

// MARK: - Notification
extension SummaryViewController {
    @objc fileprivate func handleUserDefaultsDidChange(_ notification: Notification) {
        reorderLibraryData()
        updateView()
    }
}

// MARK: - Navigation
extension SummaryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "librarySegue":
            let destinationViewController = (segue.destination as! UINavigationController).childViewControllers.first as! LibraryViewController
            if sender is String { // Handoff
                let libraryId = sender as! String
                destinationViewController.libraryId = libraryId
            } else {
                guard let selectedRow = (table.indexPathForSelectedRow as IndexPath?)?.row else { return }
                let libraryData = summaryData.libraries[selectedRow]
                destinationViewController.libraryId = libraryData.libraryId
            }
        default: break
        }
    }
}

// MARK: - Action
extension SummaryViewController {
    @objc fileprivate func updateData() {
        dataState = .fetching
        kuStudy.requestSummaryData(onLibrarySuccess: { (libraryData) in
            
        }, onFailure: { [weak self] (error) in
            self?.error = error
            self?.dataState = .error
        }) { [weak self] (summaryData: SummaryData) in
            self?.summaryData = summaryData
            self?.reorderLibraryData()
            self?.updateView()
        }
    }
    
    fileprivate func updateView() {
//        if let usedSeats = summaryData.usedSeats {
//            usedLabel.text = usedSeats.readable
//            laCampusUsedLabel.text = (summaryData.usedSeatsInLiberalArtCampus?.readable ?? "kuStudy.NoData".localized()) + "kuStudy.Main.Studying".localized()
//            scCampusUsedLabel.text = (summaryData.usedSeatsInScienceCampus?.readable ?? "kuStudy.NoData".localized()) + "kuStudy.Main.Studying".localized()
//        }
        table.reloadData()
    }
}

// MARK: - Peek & Pop
extension SummaryViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let locationInTableView = table.convert(location, from: view)
        guard let indexPath = table.indexPathForRow(at: locationInTableView) else { return nil }
        let libraryViewController = self.storyboard?.instantiateViewController(withIdentifier: "libraryViewController") as! LibraryViewController
        let libraryData = summaryData.libraries[indexPath.row]
        libraryViewController.libraryId = libraryData.libraryId
        previewingContext.sourceRect = view.convert(table.rectForRow(at: indexPath), from: table)
        return libraryViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

// MARK: - Handoff
extension SummaryViewController {
    fileprivate func startHandoff() {
        let activity = NSUserActivity(activityType: kuStudyHandoffSummary)
        activity.title = "Summary"
        activity.becomeCurrent()
        userActivity = activity
    }
    
    fileprivate func endHandoff() {
        userActivity?.invalidate()
    }
    
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        switch activity.activityType {
        case kuStudyHandoffSummary: break
        case kuStudyHandoffLibrary:
            let libraryId = activity.userInfo!["libraryId"]
            performSegue(withIdentifier: "librarySegue", sender: libraryId)
        default: break
        }
        super.restoreUserActivityState(activity)
    }
}

// MARK: - Table view
extension SummaryViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryData.libraries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let libraryData = summaryData.libraries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell", for: indexPath) as! LibraryTableViewCell
        cell.populate(library: libraryData)
        return cell
    }
    
    // MARK: Empty state
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
extension SummaryViewController {
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
    
    fileprivate func updateHeaderImage() {
        let libraryTypes = LibraryType.allTypes()
        
        let libraryId: String
        let isRunningTest = ProcessInfo.processInfo.arguments.contains("Snapshot") ? true : false
        if isRunningTest == true {
            // Fastlane Snapshot
            let libraryType = LibraryType.CentralSquare
            libraryId = libraryType.rawValue
        } else {
            let randomIndex = Int(arc4random_uniform(UInt32(libraryTypes.count)))
            libraryId = libraryTypes[randomIndex].rawValue
        }
        let photo = PhotoProvider.sharedProvider.photo(libraryId)
        heroImageView.image = photo.image
    }
    
    fileprivate func reorderLibraryData() {
        orderedLibraryIds = Preference.shared.libraryOrder
        
        var orderedLibraryData = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = summaryData.libraries.filter({ $0.libraryId! == libraryId }).first else { continue }
            orderedLibraryData.append(libraryData)
        }
        summaryData.libraries = orderedLibraryData
    }
}

// MARK: - Scroll view
extension SummaryViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset <= 0 {
            hideNavigation()
            navigationItem.title = nil
        } else {
            showNavigation()
            navigationItem.title = "Library"
        }
    }
}
