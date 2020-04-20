//
//  AcademicEventType.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/14.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation

public enum AcademicEventType {
    case semester
    case midterm
    case finals
    case vacation
    case custom(name: String)
    
    public var name: String {
        switch self {
        case .semester:
            return "event.semester".localizedFromKit()
        case .midterm:
            return "event.midterm".localizedFromKit()
        case .finals:
            return "event.finals".localizedFromKit()
        case .vacation:
            return "event.vacation".localizedFromKit()
        case let .custom(name):
            return name
        }
    }
}
