//
//  MainSplitViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 9. 18..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import Localize_Swift

class MainSplitViewController: UISplitViewController {
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .AllVisible
        delegate = self
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: Key command
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override var keyCommands: [UIKeyCommand]? {
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        let libraryIds = defaults.arrayForKey("libraryOrder") as! [String]
        var commands = [UIKeyCommand]()
        for (index, libraryId) in libraryIds.enumerate() {
            let libraryType = LibraryType(rawValue: libraryId)!
            let command = UIKeyCommand(input: "\(index + 1)", modifierFlags: .Command, action: #selector(gotoLibraries(_:)), discoverabilityTitle: libraryType.name)
            commands.append(command)
        }
        let libraries = UIKeyCommand(input: ".", modifierFlags: .Command, action: #selector(gotoLibrary(_:)), discoverabilityTitle: "kuStudy.KeyCommand.Libraries".localized())
        let settings = UIKeyCommand(input: ",", modifierFlags: .Command, action: #selector(gotoPreferences(_:)), discoverabilityTitle: "kuStudy.KeyCommand.Preferences".localized())
        return commands + [libraries, settings]
    }
    
    // MARK: Action
    @objc private func gotoLibraries(sender: UIKeyCommand) {
        let tabBarController = childViewControllers.first as! MainTabBarController
        tabBarController.selectedIndex = 0
        
        let summaryViewController = (tabBarController.childViewControllers.first as! UINavigationController).childViewControllers.first as! SummaryViewController
        let defaults = NSUserDefaults(suiteName: kuStudySharedContainer) ?? NSUserDefaults.standardUserDefaults()
        let libraryIds = defaults.arrayForKey("libraryOrder") as! [String]
        let index = Int(sender.input)! - 1
        let libraryId = libraryIds[index]
        summaryViewController.performSegueWithIdentifier("librarySegue", sender: libraryId)
    }
    
    @objc private func gotoLibrary(sender: UIKeyCommand) {
        let tabBarController = childViewControllers.first as! MainTabBarController
        tabBarController.selectedIndex = 0
    }
    
    @objc private func gotoPreferences(sender: UIKeyCommand) {
        let tabBarController = childViewControllers.first as! MainTabBarController
        tabBarController.selectedIndex = 1
    }
}

// MARK: - Split view
extension MainSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController) -> UIViewController? {
        let tabBarController = splitViewController.childViewControllers.first as! MainTabBarController
        let masterNavigationController = tabBarController.childViewControllers.first as! UINavigationController
        let secondaryNavigationController = tabBarController.childViewControllers.last as! UINavigationController
        if masterNavigationController.childViewControllers.count >= 1 {
            masterNavigationController.popViewControllerAnimated(false)
        }
        if secondaryNavigationController.childViewControllers.count >= 1 {
            secondaryNavigationController.popViewControllerAnimated(false)
        }
        return nil
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? LibraryViewController else { return false }
        if topAsDetailController.libraryId == nil {
            // Return true to indicate that we have handled the collpase by doing nothing; the secondary controller will be discarded
            return true
        }
        return false
    }

    func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
        if splitViewController.collapsed == true {
            let tabBarController = splitViewController.childViewControllers.first as! MainTabBarController
            let masterNavigationController = tabBarController.childViewControllers.first as? UINavigationController
            let secondNavigationController = tabBarController.childViewControllers.last as? UINavigationController
            if let detailViewController = vc.childViewControllers.first as? LibraryViewController {
                masterNavigationController?.pushViewController(detailViewController, animated: true)
            } else {
                if splitViewController.collapsed == true {
                    let navigationController = vc as! UINavigationController
                    let vc = navigationController.childViewControllers.first!
                    secondNavigationController?.pushViewController(vc, animated: true)
                } else {
                    secondNavigationController?.pushViewController(vc, animated: true)
                }
            }
            return true
        }
        return false
    }
}
