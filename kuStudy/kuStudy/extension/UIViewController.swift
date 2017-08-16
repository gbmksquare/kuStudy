//
//  UIViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 8. 16..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: Localizations.Alert.Action.Confirm, style: .default, handler: nil)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
}
