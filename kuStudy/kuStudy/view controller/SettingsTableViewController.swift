//
//  SettingsTableViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 1. 25..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import AcknowList
//import StoreKit
import Crashlytics

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
        switch  cell.tag {
        case 900: // Open source
            let path = NSBundle.mainBundle().pathForResource("Pods-kuStudy-acknowledgements", ofType: "plist")
            let acknowledgementViewController = AcknowListViewController(acknowledgementsPlistPath: path)
            let detailNavigationController = UINavigationController(rootViewController: acknowledgementViewController)
            navigationController?.showDetailViewController(detailNavigationController, sender: true)
        case 998: // Recommend to a friend
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let message = "kuStudy.Settings.Recommend".localized() + "\n\nhttps://geo.itunes.apple.com/kr/app/kustudy-golyeodaehaggyo-yeollamsil/id925255895?mt=8&ign-mpt=uo%3D4"
            let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            activityVC.popoverPresentationController?.permittedArrowDirections = .Any
            activityVC.popoverPresentationController?.sourceView = cell
            activityVC.popoverPresentationController?.sourceRect = cell.bounds
            presentViewController(activityVC, animated: true, completion: { 
                Answers.logInviteWithMethod("iOS", customAttributes: ["Device": UIDevice.currentDevice().model, "Version": UIDevice.currentDevice().systemVersion])
            })
        case 999: // App Store review
            // TODO: On iOS 9, this doesn't allow directly showing review page.
//            let storeVC = SKStoreProductViewController()
//            let parameters = [SKStoreProductParameterITunesItemIdentifier: "925255895"]
//            storeVC.delegate = self
//            storeVC.loadProductWithParameters(parameters, completionBlock: nil)
//            presentViewController(storeVC, animated: true, completion: nil)
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            guard let appUrl = NSURL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=925255895&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software") else { return }
            let application = UIApplication.sharedApplication()
            if application.canOpenURL(appUrl) {
                application.openURL(appUrl)
                Answers.logCustomEventWithName("Rate on App Store", customAttributes: ["Device": UIDevice.currentDevice().model, "Version": UIDevice.currentDevice().systemVersion])
            }
        default: break
        }
    }
}

//extension SettingsTableViewController: SKStoreProductViewControllerDelegate {
//    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
//        if let indexPath = tableView.indexPathForSelectedRow {
//            tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        }
//        viewController.dismissViewControllerAnimated(true, completion: nil)
//    }
//}
