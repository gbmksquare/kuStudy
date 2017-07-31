//
//  TodayExtensionOrderTableViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 10..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class TodayExtensionOrderTableViewController: UITableViewController {
    private var libraryTypes: [LibraryType]!
    private var orderedLibraryIds: [String]!
    private var hiddenLibraryIds: [String]!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        orderedLibraryIds = Preference.shared.widgetLibraryOrder
        hiddenLibraryIds = Preference.shared.widgetLibraryHidden
        libraryTypes = LibraryType.allTypes()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
    }
}

// MARK: Data source
extension TodayExtensionOrderTableViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return Localizations.Settings.Today.Table.Header.Show
        case 1: return Localizations.Settings.Today.Table.Header.Hide
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0: return Localizations.Settings.Today.Table.Footer.Instruction
        case 1: return Localizations.Settings.Today.Table.Footer.Hidden
        default: return ""
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return orderedLibraryIds?.count ?? 0
        case 1: return hiddenLibraryIds?.count ?? 0
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let libraryId: String
        switch indexPath.section {
        case 0: libraryId = orderedLibraryIds[indexPath.row]
        case 1: libraryId = hiddenLibraryIds[indexPath.row]
        default: return cell
        }
        let libraryType = libraryTypes.filter({ $0.rawValue == libraryId }).first!
        cell.textLabel?.text = libraryType.name
        return cell
    }
}

// MARK: Move
extension TodayExtensionOrderTableViewController {
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
        let fromSection = sourceIndexPath.section
        let fromRow = sourceIndexPath.row
        let toSection = destinationIndexPath.section
        let toRow = destinationIndexPath.row
        
        let movingLibraryId: String
        if fromSection == 0 {
            movingLibraryId = orderedLibraryIds[fromRow]
            orderedLibraryIds.remove(at: fromRow)
        } else {
            movingLibraryId = hiddenLibraryIds[fromRow]
            hiddenLibraryIds.remove(at: fromRow)
        }
        
        if toSection == 0 {
            orderedLibraryIds.insert(movingLibraryId, at: toRow)
        } else {
            hiddenLibraryIds.insert(movingLibraryId, at: toRow)
        }
        
        Preference.shared.widgetLibraryOrder = orderedLibraryIds
        Preference.shared.widgetLibraryHidden = hiddenLibraryIds
    }
}
