//
//  UIDevice.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 7. 1..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit

extension UIDevice {
    var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
