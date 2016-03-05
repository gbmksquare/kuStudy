//
//  Library.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 4..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation

public typealias ReadingRoom = Library
public typealias ReadingRoomViewModel = LibraryViewModel

public class Library {
    public var id: Int
    public var key: String
    public var total: Int
    public var available: Int
    
    public init(id: Int, key: String, total: Int, available: Int) {
        self.id = id
        self.key = key
        self.total = total
        self.available = available
    }
}

public class LibraryViewModel {
    public let id: Int
    public let key: String
    public let total: Int
    public let available: Int
    public var used: Int { return total - available }
    
    public var name: String { return NSLocalizedString(key, bundle: NSBundle(forClass: self.dynamicType), comment: "Library key") }
    
    private var numberFormatter: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        return formatter
    }
    public var totalString: String { return numberFormatter.stringFromNumber(total) ?? "" }
    public var availableString: String { return numberFormatter.stringFromNumber(available) ?? "" }
    public var usedString: String { return numberFormatter.stringFromNumber(used) ?? "" }
    
    public var usedPercentage: Float { return Float(used) / Float(total) }
    public var usedPercentageString: String { return "\(Int(usedPercentage * 100))%" }
    public var usedPercentageColor: UIColor {
        switch usedPercentage {
        case let p where p > 0.9: return kuStudyColorError
        case let p where p > 0.8: return kuStudyColorWarning
        case let p where p > 0.7: return kuStudyColorLightWarning
        default: return kuStudyColorConfirm
        }
    }
    
    public init(library: Library) {
        id = library.id
        key = library.key
        total = library.total
        available = library.available
    }
}
