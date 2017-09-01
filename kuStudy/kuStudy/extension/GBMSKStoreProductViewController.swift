//
//  GBMSKStoreProductViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 5. 26..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import StoreKit

class GBMSKStoreProductViewController: SKStoreProductViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 11, *) {
            if traitCollection.userInterfaceIdiom == .phone {
                return .default
            } else {
                return .lightContent
            }
        } else {
            return .lightContent
        }
    }
}
