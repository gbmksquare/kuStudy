//
//  SummaryViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import MobileCoreServices
import kuStudyKit
import MXParallaxHeader
import DZNEmptyDataSet
import Crashlytics
import WatchConnectivity
import DeviceKit

enum DataSourceState {
    case fetching, error
}

class SummaryViewController: UIViewController {
    @IBOutlet private weak var table: UITableView!
    @IBOutlet private weak var header: UIView!
    
    private weak var heroImageView: UIImageView!
    private var heroImageViewHeight: CGFloat?
//    private var refreshView = RefreshEffectView()
//    private var canTriggerRefresh = true
    
    private lazy var summaryContentView = SummaryHeaderView()
    
    private lazy var gradient = CAGradientLayer()
    
    private var summary: SummaryData?
    private var dataState: DataSourceState = .fetching
    private var error: Error?
    
    private var orderedLibraryIds: [String]!
    
    private var session: WCSession?
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        kuStudy.startFecthingData(autoUpdate: Preference.shared.shouldAutoUpdate, updateInterval: Preference.shared.updateInterval)
        
        Answers.logContentView(withName: "Summary", contentType: "Summary", contentId: "0", customAttributes: ["Device": UIDevice.current.model, "Version": UIDevice.current.systemVersion])
        
        if WCSession.isSupported() == true {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startHandoff()
        updateHeaderImage()
        
        handleNavigationBar()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if (splitViewController?.childViewControllers.last?.childViewControllers.first is LibraryViewController) == false {
                if let indexPath = table.indexPathForSelectedRow {
                    table.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endHandoff()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
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
extension SummaryViewController {
    private func setup() {
        setupImageHeader()
        setupGradient()
        setupTableView()
        setupContent()
        setupNotification()
        registerPeekAndPop()
    }
    
    private func setupImageHeader() {
        table.tableHeaderView = summaryContentView
        
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        table.parallaxHeader.view = imageView
        table.parallaxHeader.mode = .fill
        heroImageView = imageView
        
//        imageView.addSubview(refreshView)
//        refreshView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
        setImageHeaderHeight()
        
        if #available(iOS 11.0, *) {
            imageView.accessibilityIgnoresInvertColors = true
        }
    }
    
    private func setImageHeaderHeight() {
        let height: CGFloat
        if traitCollection.verticalSizeClass == .compact {
            height = 120
        } else if traitCollection.userInterfaceIdiom == .phone {
            height = Device().isOneOf([.iPhoneX, .simulator(.iPhoneX)]) == true ? 180 : 160
        } else {
            height = 160
        }
        table.parallaxHeader.height = height
        heroImageViewHeight = height
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
        table.register(LibraryCell.self, forCellReuseIdentifier: "cell")
        
        if #available(iOS 11.0, *) {
            table.dragInteractionEnabled = true
            table.dragDelegate = self
        }
    }
    
    private func setupContent() {
        title = Localizations.Title.Library
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleShouldUpdateImage(_:)), name: MediaManager.shouldUpdateImageNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDefaultsDidChange(_: )), name: UserDefaults.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdated(_:)), name: kuStudy.didUpdateDataNotification, object: nil)
    }
    
    private func registerPeekAndPop() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
}

// MARK: - Notification
extension SummaryViewController {
    @objc private func handleShouldUpdateImage(_ notification: Notification) {
        UIView.transition(with: heroImageView,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.heroImageView.image = MediaManager.shared.mediaForMain()?.image
            }, completion: nil)
    }
    
    @objc private func handleUserDefaultsDidChange(_ notification: Notification) {
        reorderLibraryData()
        updateView()
    }
    
    @objc private func handleDataUpdated(_ notification: Notification) {
        if let summary = kuStudy.summaryData {
            if summary.libraries.count > 0 {
                self.summary = summary
                reorderLibraryData()
                updateView()
                return
            }
        }
//        refreshView.endRefreshing()
        // Error
        summary = nil
        error = kuStudy.errors?.first
        dataState = .error
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
                destinationViewController.library = LibraryType(rawValue: libraryId) ?? LibraryType.centralSquare
            } else {
                guard let selectedRow = (table.indexPathForSelectedRow as IndexPath?)?.row else { return }
                let libraryData = summary?.libraries[selectedRow]
                destinationViewController.library = libraryData?.libraryType ?? LibraryType.centralSquare
            }
        default: break
        }
    }
}

// MARK: - Action
extension SummaryViewController {
    private func updateView() {
        summaryContentView.summary = summary
        table.reloadData()
    }
    
//    private func triggerRefresh() {
//        guard canTriggerRefresh == true else {
//            refreshView.endRefreshing()
//            return
//        }
//        kuStudy.requestUpdateData()
//    }
}

// MARK: - Peek & Pop
extension SummaryViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let locationInTableView = table.convert(location, from: view)
        guard let indexPath = table.indexPathForRow(at: locationInTableView) else { return nil }
        let libraryViewController = self.storyboard?.instantiateViewController(withIdentifier: "libraryViewController") as! LibraryViewController
        let libraryData = summary?.libraries[indexPath.row]
        libraryViewController.library = libraryData?.libraryType ?? LibraryType.centralSquare
        previewingContext.sourceRect = view.convert(table.rectForRow(at: indexPath), from: table)
        return libraryViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

// MARK: - Handoff
extension SummaryViewController {
    private func startHandoff() {
        let activity = NSUserActivity(activityType: kuStudyHandoffSummary)
        activity.title = "Summary"
        activity.becomeCurrent()
        userActivity = activity
    }
    
    private func endHandoff() {
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

// MARK: - Key command
extension SummaryViewController {
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var keyCommands: [UIKeyCommand]? {
        var commands = [UIKeyCommand]()
        let libraryIds = Preference.shared.libraryOrder
        for (index, libraryId) in libraryIds.enumerated() {
            let libraryType = LibraryType(rawValue: libraryId)!
            let command = UIKeyCommand(input: "\(index + 1)", modifierFlags: .init(rawValue: 0), action: #selector(gotoLibraries(_:)), discoverabilityTitle: libraryType.name)
            commands.append(command)
        }
        return commands
    }
    
    @objc private func gotoLibraries(_ sender: UIKeyCommand) {
        let libraryIds = Preference.shared.libraryOrder
        let index = Int(sender.input!)! - 1
        let libraryId = libraryIds[index]
        performSegue(withIdentifier: "librarySegue", sender: libraryId)
    }
}

// MARK: - UI
extension SummaryViewController {
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
    
    private func updateHeaderImage() {
        heroImageView.image = MediaManager.shared.mediaForMain()?.image
    }
    
    private func reorderLibraryData() {
        orderedLibraryIds = Preference.shared.libraryOrder
        
        var orderedLibraryData = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = summary?.libraries.filter({ $0.libraryType!.identifier == libraryId }).first else { continue }
            orderedLibraryData.append(libraryData)
        }
        summary?.libraries = orderedLibraryData
    }
    
    private func handleNavigationBar() {
        let scrollView = table as UIScrollView
        let offset = scrollView.contentOffset.y
        
        // Navigation bar
        if offset >= 0 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        // Refresh
//        guard let heroImageViewHeight = heroImageViewHeight else { return }
//        if offset <= -(heroImageViewHeight * 1.5) {
//            refreshView.startRefreshing()
//            triggerRefresh()
//            canTriggerRefresh = false
//        }
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

// MARK: - Table view
extension SummaryViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "librarySegue", sender: self)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let fromRow = sourceIndexPath.row
        let toRow = destinationIndexPath.row
        let moveLibraryId = orderedLibraryIds[fromRow]
        orderedLibraryIds.remove(at: fromRow)
        orderedLibraryIds.insert(moveLibraryId, at: toRow)
        
        Preference.shared.libraryOrder = orderedLibraryIds
        
        // Send settings to watch
        do {
            try session?.updateApplicationContext(["libraryOrder": orderedLibraryIds])
        } catch { }
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summary?.libraries.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell", for: indexPath) as! LibraryTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LibraryCell
        cell.accessoryType = .disclosureIndicator
        cell.libraryData = summary?.libraries[indexPath.row]
//        if let libraryData = summary?.libraries[indexPath.row] {
//            cell.populate(library: libraryData)
//        }
//        cell.updateInterface(for: traitCollection)
        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: Empty state
    func emptyDataSetDidTap(_ scrollView: UIScrollView!) {
        kuStudy.requestUpdateData()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = dataState == .fetching ? Localizations.Table.Label.Loading : (error?.localizedDescription ?? Localizations.Table.Label.Error)
        let attribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]
        return NSAttributedString(string: text, attributes: attribute)
    }
}

// MARK: - Drag & Drop
@available(iOS 11.0, *)
extension SummaryViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let libraryData = summary?.libraries[indexPath.row] else { return [] }
        let string = Localizations.Share.Library.Data(libraryData.libraryName, libraryData.total.readable, libraryData.available.readable, libraryData.occupied.readable)
        guard let data = string.data(using: .utf8) else { return [] }
        
        let stringItem = UIDragItem(itemProvider: NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String))
        return [stringItem]
    }
    
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return self.tableView(tableView, itemsForBeginning: session, at: indexPath)
    }
}

// MARK: - Scroll view
extension SummaryViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleNavigationBar()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollOffset()
//        canTriggerRefresh = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        handleScrollOffset()
    }
}

// MARK: - Watch
extension SummaryViewController: WCSessionDelegate {
    // MARK: Watch
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
