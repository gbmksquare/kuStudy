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
