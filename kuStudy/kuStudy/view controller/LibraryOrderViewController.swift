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
        tableView.allowsSelectionDuringEditing = true
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return orderedLibraryIds.count
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return Localizations.Label.Troubleshoot
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1: return Localizations.Label.TroubleshootDescription
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.section {
        case 0:
            let libraryId = orderedLibraryIds[indexPath.row]
            let libraryType = libraryTypes.filter({ $0.rawValue == libraryId }).first!
            cell.textLabel?.text = libraryType.name
        case 1:
            cell.textLabel?.text = Localizations.Action.ResetOrder
        default: break
        }
        return cell
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Preference.shared.resetLibraryOrder()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0: return true
        default: return false
        }
    }
    
    // Delegate - Move
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0: return true
        default: return false
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section == proposedDestinationIndexPath.section {
            return proposedDestinationIndexPath
        } else {
            return sourceIndexPath
        }
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
