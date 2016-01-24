//
//  Database.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import Foundation
import RealmSwift

public extension kuStudy {
    public class func infoRealm() -> Realm? {
        let realmUrl = sharedContainerUrl?.URLByAppendingPathComponent("info.realm")
        
        if let realmPath = realmUrl?.path {
            var configuration = Realm.Configuration()
            configuration.path = realmPath
            Realm.Configuration.defaultConfiguration = configuration
        }
        
        do {
            return try Realm()
        } catch {
            return nil
        }
    }
}

// MARK: Realm model
public class LibraryInfoRecord: Object {
    public dynamic var id = 0
    public dynamic var key = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
