//
//  SummaryViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import SwiftyJSON

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    // MARK: Model
    var summary: Summary?
    var libraries = [Library]()
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
    }
    
    // MARK: Action
    private func refreshData() {
        kuStudy().requestSummary { (json, error) -> Void in
            if let json = json {
                let total = json["content"]["total"].intValue
                let available = json["content"]["available"].intValue
                self.summary = Summary(total: total, available: available)
                
                let libraries = json["content"]["libraries"].arrayValue
                for library in libraries {
                    let id = library["id"].intValue
                    let total = library["total"].intValue
                    let available = library["available"].intValue
                    let library = Library(id: id, total: total, available: available)
                    self.libraries.append(library)
                }
                self.tableView.reloadData()
            } else {
                // TODO: Handle error
            }
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "librarySegue":
                let destinationViewController = segue.destinationViewController as! LibraryViewController
                destinationViewController.libraryId = tableView.indexPathForSelectedRow()!.row + 1
            default: break
            }
        }
    }
    
    // MARK: Table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("libraryCell", forIndexPath: indexPath) as! LibraryTableViewCell
        let library = libraries[indexPath.row]
        let libraryViewModel = LibraryViewModel(library: library)
        
        cell.nameLabel.text = libraryViewModel.name
        cell.totalLabel.text = libraryViewModel.totalString
        cell.availableLabel.text = libraryViewModel.availableString
        cell.usedPercentage.progress = libraryViewModel.usedPercentage
        cell.usedPercentage.tintColor = libraryViewModel.usedPercentageColor
        
        return cell
    }
}
