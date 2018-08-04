//
//  LibraryCellTypeViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 7. 29..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryCellTypeViewController: UIViewController {
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var sampleLibraryData = LibraryData(libraryId: LibraryType.centralSquare.rawValue,JSONString: sampleLibraryJsonString)
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Action
    
    // MARK: - Setup
    private func setup() {
        title = Localizations.Label.Settings.CellType
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        LibraryCellType.allTypes.forEach {
            tableView.register($0.cellClass, forCellReuseIdentifier: $0.preferredReuseIdentifier)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Table
extension LibraryCellTypeViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row % 2 == 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.section
        let type = LibraryCellType.allTypes[index]
        Preference.shared.libraryCellType = type
        tableView.reloadData()
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return LibraryCellType.allTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let index = indexPath.section
            let type = LibraryCellType.allTypes[index]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = type.name
            if type == Preference.shared.libraryCellType {
                cell.accessoryType = .checkmark
                cell.tintColor = .theme
            } else {
                cell.accessoryType = .none
            }
            return cell
        } else {
            let index = indexPath.section
            let type = LibraryCellType.allTypes[index]
            switch type {
            case .classic:
                let cell = tableView.dequeueReusableCell(withIdentifier: type.preferredReuseIdentifier, for: indexPath) as! ClassicLibraryCell
                cell.libraryData = sampleLibraryData
                return cell
            case .compact:
                let cell = tableView.dequeueReusableCell(withIdentifier: type.preferredReuseIdentifier, for: indexPath) as! CompactLibraryCell
                cell.libraryData = sampleLibraryData
                return cell
            case .veryCompact:
                let cell = tableView.dequeueReusableCell(withIdentifier: type.preferredReuseIdentifier, for: indexPath) as! VeryCompactLibraryCell
                cell.libraryData = sampleLibraryData
                return cell
            }
        }
    }
}

let sampleLibraryJsonString = """
{
"code": 1,
"status": 200,
"message": "SUCCESS",
"data": [
{
"code": 6,
"name": "유선노트북열람실",
"nameEng": "Reading Room 1(Laptop)",
"scCkMi": "10",
"bgImg": "/resources/image/layout/centralPlaza/csquare01.jpg",
"previewImg": "/resources/image/appBg/centralPlaza/유선노트북열람실.jpg",
"miniMapImg": "/resources/image/minimap/centralPlaza/wiredNotebook.png",
"noteBookYN": "Y",
"maxMi": 240,
"maxRenewMi": 240,
"startTm": "0000",
"endTm": "0000",
"wkStartTm": "0000",
"wkEndTm": "0000",
"wkSetting": "NNNNNNN",
"wkTimeUseSetting": "YNNNNNY",
"wkRsrvUseYn": "Y",
"cnt": 258,
"available": 258,
"inUse": 58,
"fix": 0,
"disabled": 0,
"fixedSeat": 0,
"normal": 0,
"unavailable": 0
},
{
"code": 7,
"name": "열람전용실",
"nameEng": "Reading Room 2",
"scCkMi": "10",
"bgImg": "/resources/image/layout/centralPlaza/csquare02.jpg",
"previewImg": "/resources/image/appBg/centralPlaza/열람전용실.jpg",
"miniMapImg": "/resources/image/minimap/centralPlaza/openSpace.png",
"noteBookYN": "N",
"maxMi": 240,
"maxRenewMi": 240,
"startTm": "0000",
"endTm": "0000",
"wkStartTm": "0000",
"wkEndTm": "0000",
"wkSetting": "NNNNNNN",
"wkTimeUseSetting": "YNNNNNY",
"wkRsrvUseYn": "Y",
"cnt": 326,
"available": 325,
"inUse": 34,
"fix": 1,
"disabled": 0,
"fixedSeat": 0,
"normal": 0,
"unavailable": 0
},
{
"code": 10,
"name": "대학원열람실",
"nameEng": "Reading Room 3(Grad)",
"scCkMi": "10",
"bgImg": "/resources/image/layout/centralPlaza/csquare05.jpg",
"previewImg": "/resources/image/appBg/centralPlaza/대학원열람실.jpg",
"miniMapImg": "/resources/image/minimap/centralPlaza/graduate.png",
"noteBookYN": "N",
"maxMi": 240,
"maxRenewMi": 240,
"startTm": "0000",
"endTm": "0000",
"wkStartTm": "0000",
"wkEndTm": "0000",
"wkSetting": "NNNNNNN",
"wkTimeUseSetting": "YNNNNNY",
"wkRsrvUseYn": "Y",
"cnt": 120,
"available": 120,
"inUse": 22,
"fix": 0,
"disabled": 0,
"fixedSeat": 0,
"normal": 0,
"unavailable": 0
}
],
"success": true
}
"""
