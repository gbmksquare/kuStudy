//
//  SectorCellTypeViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2018. 8. 4..
//  Copyright © 2018년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class SectorCellTypeViewController: UIViewController {
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var sampleSectorData = SectorData(JSONString: sampleSectorJsonString)
    
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
        SectorCellType.allTypes.forEach {
            tableView.register($0.cellClass, forCellReuseIdentifier: $0.preferredReuseIdentifier)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Table
extension SectorCellTypeViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row % 2 == 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.section
        let type = SectorCellType.allTypes[index]
        Preference.shared.sectorCellType = type
        tableView.reloadData()
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectorCellType.allTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let index = indexPath.section
            let type = SectorCellType.allTypes[index]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = type.name
            if type == Preference.shared.sectorCellType {
                let button = UIButton(type: .custom)
                button.setImage(#imageLiteral(resourceName: "selection_checkmark"), for: .normal)
                button.frame = CGRect(origin: .zero, size: #imageLiteral(resourceName: "selection_checkmark").size)
                button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                cell.accessoryView = button
//                cell.accessoryType = .checkmark
//                cell.tintColor = .theme
            } else {
                cell.accessoryView = nil
//                cell.accessoryType = .none
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let index = indexPath.section
            let type = SectorCellType.allTypes[index]
            switch type {
            case .classic:
                let cell = tableView.dequeueReusableCell(withIdentifier: type.preferredReuseIdentifier, for: indexPath) as! ClassicSectorCell
                cell.sectorData = sampleSectorData
                return cell
            case .compact:
                let cell = tableView.dequeueReusableCell(withIdentifier: type.preferredReuseIdentifier, for: indexPath) as! CompactSectorCell
                cell.sectorData = sampleSectorData
                return cell
            case .veryCompact:
                let cell = tableView.dequeueReusableCell(withIdentifier: type.preferredReuseIdentifier, for: indexPath) as! VeryCompactSectorCell
                cell.sectorData = sampleSectorData
                return cell
            }
        }
    }
}

private let sampleSectorJsonString = """
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
}
"""

