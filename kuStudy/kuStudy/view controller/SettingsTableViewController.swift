//
//  SettingsTableViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 1. 25..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import AcknowList
import StoreKit
import Crashlytics

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        appIconImageView.layer.cornerRadius = 8
        versionLabel.text = "kuStudy " + UIApplication.versionString
        clearsSelectionOnViewWillAppear = false
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .automatic
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // iOS Bug: http://stackoverflow.com/questions/19379510/uitableviewcell-doesnt-get-deselected-when-swiping-back-quickly
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        // Deselct cell if detail view does not match master view
        if UIDevice.current.userInterfaceIdiom == .pad {
            if (splitViewController?.childViewControllers.last?.childViewControllers.first is LibraryViewController) == true {
                if let indexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Adjust table footer view height to support dynamic type
        if let footer = tableView.tableFooterView {
            let height = footer.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = footer.frame
            if frame.height != height {
                frame.size.height = height
                footer.frame = frame
                tableView.tableFooterView = footer
            }
        }
    }
}

extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        switch  cell.tag {
        case 900: // Open source
            let path = Bundle.main.path(forResource: "Pods-kuStudy-acknowledgements", ofType: "plist")
            let acknowledgementViewController = AcknowListViewController(acknowledgementsPlistPath: path)
            let detailNavigationController = UINavigationController(rootViewController: acknowledgementViewController)
            navigationController?.showDetailViewController(detailNavigationController, sender: true)
        case 998: // Recommend to a friend
            tableView.deselectRow(at: indexPath, animated: true)
            let message = Localizations.Settings.Recommend.Message
            let url = URL(string: "https://geo.itunes.apple.com/kr/app/kustudy-golyeodaehaggyo-yeollamsil/id925255895?mt=8&ign-mpt=uo%3D4")! as Any
            let activityVC = UIActivityViewController(activityItems: [message, url], applicationActivities: nil)
            activityVC.popoverPresentationController?.permittedArrowDirections = .any
            activityVC.popoverPresentationController?.sourceView = cell
            activityVC.popoverPresentationController?.sourceRect = cell.bounds
            activityVC.completionWithItemsHandler = { (_, _, _, _) in
                // Show rate on App Store
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                }
            }
            present(activityVC, animated: true, completion: { 
                Answers.logInvite(withMethod: "iOS", customAttributes: ["Device": UIDevice.current.model, "Version": UIDevice.current.systemVersion])
            })
        case 999: // App Store review
            let storeVC = GBMSKStoreProductViewController()
            let parameters = [SKStoreProductParameterITunesItemIdentifier: "925255895"]
            storeVC.delegate = self
            storeVC.loadProduct(withParameters: parameters, completionBlock: { [weak self] (result, error) in
                self?.present(storeVC, animated: true, completion: nil)
            })
            
            tableView.deselectRow(at: indexPath, animated: true)
        default: break
        }
    }
}

extension SettingsTableViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        viewController.dismiss(animated: true, completion: nil)
    }
}
