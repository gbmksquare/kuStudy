//
//  ReuseIdentifiable.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/03/29.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - Cell
extension UITableViewCell: ReuseIdentifiable { }
extension UICollectionReusableView: ReuseIdentifiable { }
