//
//  Identifiable.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 3. 7..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation

public protocol Identifiable {
    var id: Int { get }
    var key: String { get }
}

extension Identifiable {
    public var name: String {
        return NSLocalizedString(key,
            bundle: NSBundle(forClass: kuStudy.self),
            comment: "Library key")
    }
}
