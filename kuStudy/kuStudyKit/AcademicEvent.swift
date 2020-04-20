//
//  AcademicEvent.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/14.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation

public struct AcademicEvent {
    public let type: AcademicEventType
    public let duration: DateInterval
    
    public var daysFromToday: Int {
        return duration.end.daysFromToday
    }
}
