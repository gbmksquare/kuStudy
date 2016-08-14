//
//  AcknowledgementViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 14..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class AcknowledgementViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var photographers: [Photographer] {
        return PhotoProvider.sharedProvider.photographers
    }
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension AcknowledgementViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photographers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let photographer = photographers[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("photographerCell", forIndexPath: indexPath) as! PhotographerCell
        cell.populate(photographer)
        return cell
    }
}
