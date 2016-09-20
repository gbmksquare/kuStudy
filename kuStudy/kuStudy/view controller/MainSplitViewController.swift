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
        guard let tab = splitViewController.childViewControllers.first as? MainTabBarController else { return nil }
        guard let navigations = tab.childViewControllers as? [UINavigationController] else { return nil }
        if let navigation = navigations.first where navigation.childViewControllers.count > 1 {
            return navigation.popViewControllerAnimated(false)
        }
        if let navigation = navigations.last where navigation.childViewControllers.count > 1 {
            if let vc = navigation.popViewControllerAnimated(false) {
                let navigation = UINavigationController(rootViewController: vc)
                return navigation
            } else {
                return nil
            }
        }
        return nil
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        guard let tab = primaryViewController as? MainTabBarController else { return false }
        guard let detailNavigation = secondaryViewController as? UINavigationController else { return false }
        
        if detailNavigation.childViewControllers.first is LibraryViewController {
            return false
        } else if let vc = detailNavigation.childViewControllers.first {
            guard let navigation = tab.selectedViewController as? UINavigationController else { return false }
            navigation.pushViewController(vc, animated: false)
            return true
        }
        return false
    }

    func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
        guard let tab = splitViewController.childViewControllers.first as? MainTabBarController else { return false }
        guard let navigations = tab.childViewControllers as? [UINavigationController] else { return false }
        guard let detailNavigation = vc as? UINavigationController else { return false }
        
        if let vc = detailNavigation.childViewControllers.first as? LibraryViewController {
            if splitViewController.collapsed == true {
                navigations.first?.pushViewController(vc, animated: true)
            } else {
                return false
            }
        } else {
            if splitViewController.collapsed == true {
                guard let vc = detailNavigation.childViewControllers.first else { return true }
                navigations.last?.pushViewController(vc, animated: true)
            } else {
                navigations.last?.pushViewController(vc, animated: true)
            }
        }
        return true
    }
}
