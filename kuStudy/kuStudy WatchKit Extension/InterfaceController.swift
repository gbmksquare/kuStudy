//
//  InterfaceController.swift
//  kuStudy WatchKit Extension
//
//  Created by 구범모 on 2015. 6. 1..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import WatchKit
import Foundation
import kuStudyKit
import SwiftyJSON

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var availableLabel: WKInterfaceLabel!
    
    // MARK: Model
    var summary: Summary?
    var libraries = [Library]()
    
    // MARK: Table
    private func refreshData() {
        if let summary = summary {
            availableLabel.setText("\(summary.available) left")
        }
        
        // Refresh table
        table.setNumberOfRows(libraries.count, withRowType: "libraryCell")
        for index in 0 ..< libraries.count {
            let library = libraries[index]
            let libraryViewModel = LibraryViewModel(library: library)
            let row = table.rowControllerAtIndex(index) as! LibraryCell
            row.nameLabel.setText(libraryViewModel.name)
            row.availableLabel.setText(libraryViewModel.availableString)
        }
    }
    
    // MARK: Segue
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        switch segueIdentifier {
        case "libraryDetail":
            return [libraries[rowIndex].id]
        default: return nil
        }
    }

    // MARK: Watch
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        WKInterfaceController.openParentApplication([kuStudyWatchKitRequestKey: kuStudyWatchKitRequestSummary],
            reply: { (replyInfo, error) -> Void in
                if let summaryDict = replyInfo[kuStudyWatchKitRequestSummary] as? NSDictionary {
                    let json = JSON(summaryDict)
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
                    self.refreshData()
                } else {
                    // TODO: Handle error
                }
        })
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
