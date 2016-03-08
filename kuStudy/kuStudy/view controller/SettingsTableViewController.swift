//
//  SettingsTableViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 1. 25..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import CTFeedback

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: Setup
    private func initialSetup() {
        appIconImageView.layer.cornerRadius = 13
        let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let build = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
        versionLabel.text = "kuStudy " + "\(version) (\(build))"
    }
    
    // MARK: Action
    private func handleSendFeedback() {
        let feedback = CTFeedbackViewController(topics: CTFeedbackViewController.defaultTopics(), localizedTopics: CTFeedbackViewController.defaultLocalizedTopics())
        feedback.toRecipients = ["ksquareatm@gmail.com"]
        feedback.useHTML = true
        navigationController?.pushViewController(feedback, animated: true)
    }
    
    // MARK: Table view
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        switch cell.tag {
        case 900:
            let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
            let build = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
            cell.detailTextLabel?.text = "\(version) (\(build))"
        default: break
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        switch cell?.tag {
        case 901?: handleSendFeedback()
        default: break
        }
    }
}
