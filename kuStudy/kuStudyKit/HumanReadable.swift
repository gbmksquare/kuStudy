//
//  HumanReadable.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/01.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation

public protocol HumanReadable {
    var readable: String { get }
}

// MARK: - Extension
extension Int: HumanReadable {
    public var readable: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let number = NSNumber(integerLiteral: self)
        return formatter.string(from: number) ?? ""
    }
}

extension Float: HumanReadable {
    public var readable: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        let number = NSNumber(floatLiteral: Double(self))
        return formatter.string(from: number) ?? ""
    }
}

extension Date: HumanReadable {
    public var readable: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
