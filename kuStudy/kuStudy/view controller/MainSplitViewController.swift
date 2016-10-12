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
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .allVisible
        delegate = self
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Key command
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override var keyCommands: [UIKeyCommand]? {
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        let libraryIds = defaults.array(forKey: "libraryOrder") as! [String]
        var commands = [UIKeyCommand]()
        for (index, libraryId) in libraryIds.enumerated() {
            let libraryType = LibraryType(rawValue: libraryId)!
            let command = UIKeyCommand(input: "\(index + 1)", modifierFlags: .command, action: #selector(gotoLibraries(_:)), discoverabilityTitle: libraryType.name)
            commands.append(command)
        }
        let libraries = UIKeyCommand(input: ".", modifierFlags: .command, action: #selector(gotoLibrary(_:)), discoverabilityTitle: "kuStudy.KeyCommand.Libraries".localized())
        let settings = UIKeyCommand(input: ",", modifierFlags: .command, action: #selector(gotoPreferences(_:)), discoverabilityTitle: "kuStudy.KeyCommand.Preferences".localized())
        return commands + [libraries, settings]
    }
    
    // MARK: - Action
    @objc fileprivate func gotoLibraries(_ sender: UIKeyCommand) {
        let tabBarController = childViewControllers.first as! MainTabBarController
        tabBarController.selectedIndex = 0
        
        let summaryViewController = (tabBarController.childViewControllers.first as! UINavigationController).childViewControllers.first as! SummaryViewController
        let defaults = UserDefaults(suiteName: kuStudySharedContainer) ?? UserDefaults.standard
        let libraryIds = defaults.array(forKey: "libraryOrder") as! [String]
        let index = Int(sender.input)! - 1
        let libraryId = libraryIds[index]
        summaryViewController.performSegue(withIdentifier: "librarySegue", sender: libraryId)
    }
    
    @objc fileprivate func gotoLibrary(_ sender: UIKeyCommand) {
        let tabBarController = childViewControllers.first as! MainTabBarController
        tabBarController.selectedIndex = 0
    }
    
    @objc fileprivate func gotoPreferences(_ sender: UIKeyCommand) {
        let tabBarController = childViewControllers.first as! MainTabBarController
        tabBarController.selectedIndex = 1
    }
}

// MARK: - Split view
extension MainSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        guard let tab = splitViewController.childViewControllers.first as? MainTabBarController else { return nil }
        guard let navigations = tab.childViewControllers as? [UINavigationController] else { return nil }
        
        if let navigation = navigations.first , navigation.childViewControllers.count > 1 {
            return navigation.popViewController(animated: false)
        }
        if let navigation = navigations.last , navigation.childViewControllers.count > 1 {
            if let vc = navigation.popViewController(animated: false) {
                let navigation = UINavigationController(rootViewController: vc)
                return navigation
            } else {
                return nil
            }
        }
        return nil
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
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

    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        guard let tab = splitViewController.childViewControllers.first as? MainTabBarController else { return false }
        guard let navigations = tab.childViewControllers as? [UINavigationController] else { return false }
        guard let detailNavigation = vc as? UINavigationController else { return false }
        
        if let vc = detailNavigation.childViewControllers.first as? LibraryViewController {
            if splitViewController.isCollapsed == true {
                navigations.first?.pushViewController(vc, animated: true)
            } else {
                // !!!: When launching from Today or Handoff, split view controller is not collapsed and will show detail view controller as modal
                if traitCollection.userInterfaceIdiom == .phone && traitCollection.horizontalSizeClass == .compact {
                    navigations.first?.pushViewController(vc, animated: true)
                    return true
                }
                return false
            }
        } else {
            if splitViewController.isCollapsed == true {
                guard let vc = detailNavigation.childViewControllers.first else { return true }
                navigations.last?.pushViewController(vc, animated: true)
            } else {
                return false
            }
        }
        return true
    }
}
