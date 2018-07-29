//
//  LibraryOrderTableViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 8..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import WatchConnectivity

class LibraryOrderViewController: UIViewController, WCSessionDelegate {
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    private var libraryTypes: [LibraryType]!
    private var orderedLibraryIds: [String]!
    
    private var session: WCSession?
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        if WCSession.isSupported() == true {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    // MARK: - Action
    private func listenForUserDefaultsDidChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDefaultsDidChange(_: )), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc private func handleUserDefaultsDidChange(_ notification: Notification) {
        orderedLibraryIds = Preference.shared.libraryOrder
        tableView.reloadData()
    }
    
    // MARK: - Setup
    private func setup() {
        title = Localizations.Label.Settings.LibraryOrder
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        orderedLibraryIds = Preference.shared.libraryOrder
        libraryTypes = LibraryType.allTypes()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        listenForUserDefaultsDidChange()
    }
    
    // MARK: - Watch
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}

// MARK: - Table
extension LibraryOrderViewController: UITableViewDelegate, UITableViewDataSource {
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedLibraryIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let libraryId = orderedLibraryIds[indexPath.row]
        let libraryType = libraryTypes.filter({ $0.rawValue == libraryId }).first!
        cell.textLabel?.text = libraryType.name
        return cell
    }
    
    // Delegate - Move
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
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
}
