//
//  TimeInterval.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 12. 11..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation

extension TimeInterval {
    var readableTime: String {
        let minutes = Int(self / 60)
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        
        var string = ""
        if minutes == 1 {
            string += "1 \(Localizations.Common.Minute)"
        } else if minutes > 0 {
            string += "\(minutes) \(Localizations.Common.Minutes)"
        }
        if seconds == 1 {
            string += " 1 \(Localizations.Common.Second)"
        } else if seconds > 0 {
            string += " \(seconds) \(Localizations.Common.Seconds)"
        }
        return string
    }
}
