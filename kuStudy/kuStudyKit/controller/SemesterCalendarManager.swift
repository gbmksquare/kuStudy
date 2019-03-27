//
//  SemesterCalendarManager.swift
//  kuStudy
//
//  Created by BumMo Koo on 10/09/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import Foundation

public class SemesterCalendarManager {
    public static let shared = SemesterCalendarManager()
    
    public let activeSemester: SemesterCalendar?
    public let semesters: [SemesterCalendar]
    
    // MARK: - Initializationn
    private init() {
        let semester_18_02 = DateInterval(start: Date(dateString: "2018-09-02 +0900")!,
                                          end: Date(dateString: "2018-12-22 +0900")!)
        let midterm_18_02 = DateInterval(start: Date(dateString: "2018-10-22 +0900")!,
                                         end: Date(dateString: "2018-10-27 +0900")!)
        let finals_18_02 = DateInterval(start: Date(dateString: "2018-12-17 +0900")!,
                                        end: Date(dateString: "2018-12-22 +0900")!)
        let calendar_18_02 = SemesterCalendar(semester: semester_18_02,
                                              midterm: midterm_18_02,
                                              finals: finals_18_02)
        
        let semester_19_01 = DateInterval(start: Date(dateString: "2019-03-04 +0900")!,
                                          end: Date(dateString: "2019-06-22 +0900")!)
        let midterm_19_01 = DateInterval(start: Date(dateString: "2019-04-22 +0900")!,
                                         end: Date(dateString: "2019-04-27 +0900")!)
        let finals_19_01 = DateInterval(start: Date(dateString: "2019-06-17 +0900")!,
                                        end: Date(dateString: "2019-06-22 +0900")!)
        let calendar_19_01 = SemesterCalendar(semester: semester_19_01,
                                              midterm: midterm_19_01,
                                              finals: finals_19_01)
        
        let semester_19_02 = DateInterval(start: Date(dateString: "2019-09-02 +0900")!,
                                          end: Date(dateString: "2019-12-21 +0900")!)
        let midterm_19_02 = DateInterval(start: Date(dateString: "2019-10-21 +0900")!,
                                         end: Date(dateString: "2019-10-26 +0900")!)
        let finals_19_02 = DateInterval(start: Date(dateString: "2019-12-16 +0900")!,
                                        end: Date(dateString: "2019-12-21 +0900")!)
        let calendar_19_02 = SemesterCalendar(semester: semester_19_02,
                                              midterm: midterm_19_02,
                                              finals: finals_19_02)
        
        semesters = [calendar_18_02, calendar_19_01, calendar_19_02]
        activeSemester = semesters.filter({ $0.semester.isActive }).first
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
