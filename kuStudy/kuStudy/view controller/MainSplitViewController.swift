//
//  MainSplitViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 8. 3..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = .PrimaryOverlay
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? LibraryViewController else { return false }
        if topAsDetailController.libraryId == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
    
//    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController) -> UIViewController? {
//        <#code#>
//    }
//    
//    override func collapseSecondaryViewController(secondaryViewController: UIViewController, forSplitViewController splitViewController: UISplitViewController) {
//        <#code#>
//    }
//
//    override func separateSecondaryViewControllerForSplitViewController(splitViewController: UISplitViewController) -> UIViewController? {
//        <#code#>
//    }
    
    func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
        if splitViewController.collapsed == true {
            let tabBarController = splitViewController.childViewControllers.last as! MainTabBarController
            let masterNavigationController = tabBarController.childViewControllers.first as! UINavigationController
            let detailViewController = vc.childViewControllers.first as! LibraryViewController
            masterNavigationController.pushViewController(detailViewController, animated: true)
            return true
        }
        return false
    }
}
