//
//  String.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/14.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation

public extension String {
    func localized(bundle: Bundle = Bundle.main, comment: String = "") -> String {
        return NSLocalizedString(self, bundle: bundle, comment: comment)
    }
    
    func localizedFromKit(comment: String = "") -> String {
        return localized(bundle: Bundle(for: DataManager.self), comment: comment)
    }
}
