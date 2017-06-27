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

class LibraryOrderTableViewController: UITableViewController, WCSessionDelegate {
    fileprivate var libraryTypes: [LibraryType]!
    fileprivate var orderedLibraryIds: [String]!
    
    fileprivate var session: WCSession?
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        orderedLibraryIds = Preference.shared.libraryOrder
        libraryTypes = LibraryType.allTypes()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        
        if WCSession.isSupported() == true {
            session = WCSession.default()
            session?.delegate = self
            session?.activate()
        }
    }
    
    // MARK: Watch
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}

// MARK: Data source
extension LibraryOrderTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedLibraryIds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let libraryId = orderedLibraryIds[indexPath.row]
        let libraryType = libraryTypes.filter({ $0.rawValue == libraryId }).first!
        cell.textLabel?.text = libraryType.name
        return cell
    }
}

// MARK: Move
extension LibraryOrderTableViewController {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
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
