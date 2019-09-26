//
//  OSLog+kuStudy.swift
//  kuStudy
//
//  Created by BumMo Koo on 26/09/2019.
//  Copyright © 2019 gbmKSquare. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    // MARK: - Log
    static var `default`: OSLog {
        return log(category: "default")
    }
    
    static var todayExtension: OSLog {
        return log(category: "api")
    }
    
    // MARK: - Helper
    private static func log(category: String) -> OSLog {
        let identifier = Bundle.main.bundleIdentifier ?? "com.gbmksquare.kuapps.kuStudy"
        return OSLog(subsystem: identifier, category: category)
    }
}
