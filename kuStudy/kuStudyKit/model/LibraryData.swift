//
//  LibraryData.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 20..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation
import ObjectMapper

public class LibraryData: Mappable {
    public var libraryId: Int?
    public var sectorCount: Int?
    public var sectors: [SectorData]?
    
    required public  init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        libraryId <- map["pLibNo"]
        sectorCount <- map["statListCnt"]
        sectors <- map["statList"]
    }
}
