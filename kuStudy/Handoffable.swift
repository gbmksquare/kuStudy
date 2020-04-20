//
//  Handoffable.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/14.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

protocol Handoffable {
    func startHandoff(with activity: NSUserActivity)
    func invalidateHandoff()
}

// MARK: - Extension
extension Handoffable where Self: UIViewController {
    func startHandoff(with activity: NSUserActivity) {
        userActivity = activity
        userActivity?.becomeCurrent()
    }
    
    func invalidateHandoff() {
        userActivity?.invalidate()
    }
}
