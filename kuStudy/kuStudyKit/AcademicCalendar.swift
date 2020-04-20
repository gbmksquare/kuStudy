//
//  AcademicCalendar.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/14.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation

public struct AcademicCalendar {
    public let events: [AcademicEvent] = [
        .init(type: .semester, duration: DateInterval(start: "2020-03-16", end: "2020-06-26")),
        .init(type: .midterm, duration: DateInterval(start: "2020-05-04", end: "2020-05-08")),
        .init(type: .finals, duration: DateInterval(start: "2020-06-22", end: "2020-06-26")),
    ]
    
    public var currentEvent: AcademicEvent? {
        events
            .filter { $0.duration.isActive }
            .sorted { $0.daysFromToday < $1.daysFromToday }
            .first
    }
    
    // MARK: - Initialization
    public init() {
        
    }
}


//Today is \(formatter.string(from: Date()))
//
//Semester begins \(formatter.string(from: schoolCal.semester.start)) and ends \(formatter.string(from: schoolCal.semester.end)).
//Semester is currently on? : \(schoolCal.semester.isActive.yesOrNo)
//Days until semester ends : \(schoolCal.semester.end.daysFromToday)
//Semester lasts : \(schoolCal.semester.lasts)
//Semester progress : \(Int(((Double(schoolCal.semester.lasts) - Double(schoolCal.semester.end.daysFromToday)) / Double(schoolCal.semester.lasts)) * 100))%
//
//Midterm begins \(formatter.string(from: schoolCal.midterm.start)) and ends \(formatter.string(from: schoolCal.midterm.end)).
//Midterm is currently on? : \(schoolCal.midterm.isActive.yesOrNo)
//Days until midterm : \(schoolCal.midterm.start.daysFromToday)
//
//Finals begins \(formatter.string(from: schoolCal.finals.start)) and ends \(formatter.string(from: schoolCal.finals.end)).
//Finals is currently on? : \(schoolCal.finals.isActive.yesOrNo)
//Days until finals : \(schoolCal.finals.start.daysFromToday)

