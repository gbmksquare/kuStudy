//
//  MainSplitViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/07.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController {
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        preferredDisplayMode = .allVisible
        delegate = self
        
        let detail = UIViewController()
        detail.view.backgroundColor = .systemGroupedBackground
        
        let main = UINavigationController(rootViewController: MainViewController())
        viewControllers = [main, detail]
    }
    
    // MARK: - State restoration
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        super.restoreUserActivityState(activity)
        if let navigation = viewControllers.first {
            navigation.children.first?.restoreUserActivityState(activity)
        }
    }
}

// MARK: - Split
extension MainSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        guard let sender = sender as? UIViewController else { return false }
        if sender is MainViewController {
            return false
        } else if sender is LibraryViewController {
            sender.navigationController?.pushViewController(vc, animated: true)
            return true
        }
        return false
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if secondaryViewController is UINavigationController {
            return false
        } else {
            return true
        }
    }
}
