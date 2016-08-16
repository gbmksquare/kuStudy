//
//  SettingsTableViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 1. 25..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import AcknowList

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appIconImageView.layer.cornerRadius = 8
        versionLabel.text = "kuStudy " + UIApplication.versionString
        clearsSelectionOnViewWillAppear = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // iOS Bug: http://stackoverflow.com/questions/19379510/uitableviewcell-doesnt-get-deselected-when-swiping-back-quickly
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}

extension SettingsTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }
        if cell.tag == 900 {
            let path = NSBundle.mainBundle().pathForResource("Pods-kuStudy-acknowledgements", ofType: "plist")
            let acknowledgementViewController = AcknowListViewController(acknowledgementsPlistPath: path)
            navigationController?.pushViewController(acknowledgementViewController, animated: true)
        }
    }
}
