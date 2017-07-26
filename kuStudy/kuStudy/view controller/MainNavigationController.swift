//
//  MainNavigationController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 7. 26..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
    }
}

extension MainNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is LibraryViewController {
            
        } else if viewController is SummaryViewController {
            
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }
}
