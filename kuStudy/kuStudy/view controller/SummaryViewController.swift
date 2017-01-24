//
//  SummaryViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import DZNEmptyDataSet
import Localize_Swift
import Crashlytics

enum DataSourceState {
    case fetching, error
}

class SummaryViewController: UIViewController, UIViewControllerPreviewingDelegate {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerBlurImageView: UIImageView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var studyingDataLabel: UILabel!
    @IBOutlet weak var liberalArtCampusDataLabel: UILabel!
    @IBOutlet weak var scienceCampusDataLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    fileprivate  var refreshControl = UIRefreshControl()
    
    fileprivate var summaryData = SummaryData()
    fileprivate var dataState: DataSourceState = .fetching
    fileprivate var error: Error?
    
    fileprivate var orderedLibraryIds: [String]!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
        navigationController?.setTransparent()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updateData(_:)), for: .valueChanged)
        registerPeekAndPop()
        listenForUserDefaultsDidChange()
        updateData()
        
        Answers.logContentView(withName: "Summary", contentType: "Summary", contentId: "0", customAttributes: ["Device": UIDevice.current.model, "Version": UIDevice.current.systemVersion])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startHandoff()
        updateHeaderImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userActivity?.invalidate()
    }
    
    // MARK: Action
    @objc fileprivate func updateData(_ sender: UIRefreshControl? = nil) {
        dataState = .fetching
        kuStudy.requestSummaryData(onLibrarySuccess: { (libraryData) in
            
        }, onFailure: { [weak self] (error) in
            self?.error = error
            self?.dataState = .error
        }) { [weak self] (summaryData: SummaryData) in
            sender?.endRefreshing()
            self?.summaryData = summaryData
            self?.reorderLibraryData()
            self?.updateView()
        }
    }
    
    fileprivate func setInitialView() {
        totalLabel.text = "kuStudy.Total".localized()
        studyingLabel.text = "kuStudy.Main.Studying".localized()
        studyingDataLabel.text = "--"
    }
    
    fileprivate func updateView() {
        if let usedSeats = summaryData.usedSeats {
            studyingDataLabel.text = usedSeats.readable
            liberalArtCampusDataLabel.text = "kuStudy.LiberalArtCampus".localized() + ": " + (summaryData.usedSeatsInLiberalArtCampus?.readable ?? "0") + "kuStudy.Main.Studying".localized()
            scienceCampusDataLabel.text = "kuStudy.ScienceCampus".localized() + ": " + (summaryData.usedSeatsInScienceCampus?.readable ?? "0") + "kuStudy.Main.Studying".localized()
        }
        tableView.reloadData()
    }
    
    fileprivate func updateHeaderImage() {
        let libraryTypes = LibraryType.allTypes()
        let randomIndex = Int(arc4random_uniform(UInt32(libraryTypes.count)))
        let libraryId = libraryTypes[randomIndex].rawValue
        if let libraryType = LibraryType(rawValue: libraryId) {
            let photo = PhotoProvider.sharedProvider.photo(libraryType.rawValue)
            headerImageView.image = photo.image
            headerBlurImageView.image = photo.image
            headerBlurImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
    }
    
    fileprivate func reorderLibraryData() {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        orderedLibraryIds = defaults.array(forKey: "libraryOrder") as! [String]
        
        var orderedLibraryData = [LibraryData]()
        for libraryId in orderedLibraryIds {
            guard let libraryData = summaryData.libraries.filter({ $0.libraryId! == libraryId }).first else { continue }
            orderedLibraryData.append(libraryData)
        }
        summaryData.libraries = orderedLibraryData
    }
    
    // MARK: Peek & Pop
    fileprivate func registerPeekAndPop() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let locationInTableView = tableView.convert(location, from: view)
        guard let indexPath = tableView.indexPathForRow(at: locationInTableView) else { return nil }
        let libraryViewController = self.storyboard?.instantiateViewController(withIdentifier: "libraryViewController") as! LibraryViewController
        let libraryData = summaryData.libraries[indexPath.row]
        libraryViewController.libraryId = libraryData.libraryId
        previewingContext.sourceRect = view.convert(tableView.rectForRow(at: indexPath), from: tableView)
        return libraryViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
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
                guard let selectedRow = (tableView.indexPathForSelectedRow as IndexPath?)?.row else { return }
                let libraryData = summaryData.libraries[selectedRow]
                destinationViewController.libraryId = libraryData.libraryId
            }
        default: break
        }
    }
}

// MARK: - Table view
extension SummaryViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
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

// MARK: - Notification
extension SummaryViewController {
    fileprivate func listenForUserDefaultsDidChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDefaultsDidChange(_: )), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc fileprivate func handleUserDefaultsDidChange(_ notification: Notification) {
        reorderLibraryData()
        updateView()
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
