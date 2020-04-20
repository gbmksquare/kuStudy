//
//  URL.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/04/11.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import Foundation

extension URL {
    static let studyAreaURL = URL(string: "https://librsv.korea.ac.kr/?lang=kr")!
    static let studyAreaURLInternational = URL(string: "https://librsv.korea.ac.kr/?lang=en")!
    
    static let libraryURL = URL(string: "https://library.korea.ac.kr")!
    static let libraryURLInternational = URL(string: "https://library.korea.ac.kr")!
    
    // TODO: Dynamically generate URL
    static let academicCalendarURL = URL(string: "http://registrar.korea.ac.kr/registrar/college/schedule_new.do?cYear=2020&hakGi=1")!
    static let academicCalendarURLInternational = URL(string: "http://registrar.korea.ac.kr/registrar_en/college/schedule_new.do?cYear=2020&hakGi=1")!
    
    static let privacyPolicyURL = URL(string: "https://gbmksquare.com/kuapps/kustudy/privacy_policy_v3.html")!
    static let termsURL = URL(string: "https://gbmksquare.com/kuapps/kustudy/terms_v3.html")!
}
