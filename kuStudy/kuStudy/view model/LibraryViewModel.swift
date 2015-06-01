//
//  LibraryViewModel.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 6. 1..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import kuStudyKit
import RealmSwift

typealias ReadingRoomViewModel = LibraryViewModel

class LibraryViewModel {
    let id: Int
    let key: String
    let name: String
    
    let total: Int
    let available: Int
    var used: Int { return total - available }
    var totalString: String { return "\(total)" }
    var availableString: String { return "\(available)" }
    var usedString: String { return "\(used)" }
    
    var usedPercentage: Float { return Float(used) / Float(total) }
    var usedPercentageColor: UIColor {
        switch usedPercentage {
        case let p where p > 0.9: return UIColor.redColor()
        case let p where p > 0.8: return UIColor.orangeColor()
        case let p where p > 0.7: return UIColor.yellowColor()
        default: return UIColor.greenColor()
        }
    }
    
    init(library: Library) {
        id = library.id
        total = library.total
        available = library.available
        
        let infoRealm = kuStudy.infoRealm()
        let record = infoRealm.objectForPrimaryKey(LibraryInfoRecord.self, key: library.id)
        key = record?.key != nil ? record!.key : "unknown_id"
        name = NSLocalizedString(key, comment: "Library key") // TODO: Use localized string
    }
}
