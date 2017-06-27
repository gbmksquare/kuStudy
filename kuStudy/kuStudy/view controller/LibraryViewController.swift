//
//  LibraryViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import DZNEmptyDataSet
import Crashlytics

class LibraryViewController: UIViewController {
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerBlurImageView: UIImageView!
    
    @IBOutlet weak var libraryNameLabel: UILabel!
    
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    
    @IBOutlet weak var availablePlaceholderLabel: UILabel!
    @IBOutlet weak var totalPlaceholderLabel: UILabel!
    @IBOutlet weak var usedPlaceholderLabel: UILabel!
    
    @IBOutlet weak var photographerLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var refreshControl = UIRefreshControl()
    
    var libraryId: String! = Preference.shared.libraryOrder.first ?? "1"
    fileprivate var libraryData: LibraryData?
    
    fileprivate var dataState: DataSourceState = .fetching
    fileprivate var error: Error?
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
        navigationController?.setTransparent()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updateData(_:)), for: .valueChanged)
        updateData()
        
        if let libraryType = LibraryType(rawValue: libraryId) {
            Answers.logContentView(withName: libraryType.name, contentType: "Library", contentId: libraryId, customAttributes: ["Device": UIDevice.current.model, "Version": UIDevice.current.systemVersion])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startHandoff()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userActivity?.invalidate()
    }
    
    // MARK: Action
    @objc fileprivate func updateData(_ sender: UIRefreshControl? = nil) {
        guard let libraryId = self.libraryId else { return }
        kuStudy.requestLibraryData(libraryId: libraryId,
           onSuccess: { [weak self] (libraryData) in
            self?.libraryData = libraryData
            sender?.endRefreshing()
            self?.updateView()
        }) { [weak self] (error) in
            self?.dataState = .error
            self?.error = error
            self?.updateView()
            sender?.endRefreshing()
        }
    }
    
    fileprivate func setInitialView() {
        libraryNameLabel.text = LibraryType(rawValue: libraryId)?.name
        availablePlaceholderLabel.text  = "kuStudy.Available".localized()
        totalPlaceholderLabel.text = "kuStudy.Total".localized()
        usedPlaceholderLabel.text = "kuStudy.Used".localized()
        
        availableLabel.text = "kuStudy.NoData".localized()
        totalLabel.text = "kuStudy.NoData".localized()
        usedLabel.text = "kuStudy.NoData".localized()
        
        photographerLabel.text = ""
        let photo = PhotoProvider.sharedProvider.photo(libraryId)
        headerImageView.image = photo.image
        headerBlurImageView.image = photo.image
        headerBlurImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
        photographerLabel.text = photo.photographer.attributionString
    }
    
    fileprivate func updateView() {
        if let libraryData = libraryData {
            availableLabel.text = libraryData.availableSeats.readable
            totalLabel.text = libraryData.totalSeats.readable
            usedLabel.text = libraryData.usedSeats.readable
        }
        tableView.reloadData()
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

// MARK: Handoff
extension LibraryViewController {
    fileprivate func startHandoff() {
        guard let libraryId = self.libraryId, let name = LibraryType(rawValue: libraryId)?.name else { return }
        let activity = NSUserActivity(activityType: kuStudyHandoffLibrary)
        activity.title = name
        activity.addUserInfoEntries(from: ["libraryId": libraryId])
        activity.becomeCurrent()
        userActivity = activity
    }
}
