//
//  MainSplitViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 9. 18..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class MainSplitViewController: UISplitViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle { return .lightContent }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        delegate = self
        preferredDisplayMode = .allVisible
        
        let tab = MainTabBarController()
        let library = LibraryViewController()
        viewControllers = [tab, UINavigationController(rootViewController: library)]
    }
    
    // MARK: - Key command
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override var keyCommands: [UIKeyCommand]? {
        let libraries = UIKeyCommand(input: "l", modifierFlags: .command, action: #selector(gotoLibrary(_:)), discoverabilityTitle: Localizations.Keyboard.Libraries)
        let settings = UIKeyCommand(input: ",", modifierFlags: .command, action: #selector(gotoPreferences(_:)), discoverabilityTitle: Localizations.Keyboard.Preference)
        return [libraries, settings]
    }
    
    // MARK: - Action
    @objc private func gotoLibrary(_ sender: UIKeyCommand) {
        let tabBarController = children.first as! MainTabBarController
        tabBarController.selectedIndex = 0
    }
    
    @objc private func gotoPreferences(_ sender: UIKeyCommand) {
        let tabBarController = children.first as! MainTabBarController
        tabBarController.selectedIndex = 1
    }
}

// MARK: - Split view
extension MainSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        guard let tab = splitViewController.children.first as? MainTabBarController else { return nil }
        guard let navigations = tab.children as? [UINavigationController] else { return nil }
        
        if let navigation = navigations.first , navigation.children.count > 1 {
            return navigation.popViewController(animated: false)
        }
        if let navigation = navigations.last , navigation.children.count > 1 {
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
        
        if detailNavigation.children.first is LibraryViewController {
            return false
        } else if let vc = detailNavigation.children.first {
            guard let navigation = tab.selectedViewController as? UINavigationController else { return false }
            navigation.pushViewController(vc, animated: false)
            return true
        }
        return false
    }

    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        guard let tab = splitViewController.children.first as? MainTabBarController else { return false }
        guard let navigations = tab.children as? [UINavigationController] else { return false }
        guard let detailNavigation = vc as? UINavigationController else { return false }
        
        if let vc = detailNavigation.children.first as? LibraryViewController {
            if splitViewController.isCollapsed == true {
                navigations.first?.pushViewController(vc, animated: true)
            } else {
                // !!!: When launching from Today or Handoff, split view controller is not collapsed and will show detail view controller as modal
                if traitCollection.userInterfaceIdiom == .phone && traitCollection.horizontalSizeClass == .compact {
                    DispatchQueue.main.async {
                        navigations.first?.pushViewController(vc, animated: true)
                    }
                    return true
                }
                return false
            }
        } else {
            if splitViewController.isCollapsed == true {
                guard let vc = detailNavigation.children.first else { return true }
                DispatchQueue.main.async {
                    navigations.last?.pushViewController(vc, animated: true)
                }
            } else {
                return false
            }
        }
        return true
    }
}
