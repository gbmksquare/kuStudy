//
//  TodayViewControllerTable.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 10. 12..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let libraryId = summaryData.libraries[indexPath.row].libraryId else { return }
        openApp(libraryId: libraryId)
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
        cell.populate(libraryData)
        return cell
    }
}
