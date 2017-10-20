//
//  API.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 5. 20..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

public typealias FailureHandler = (_ error: Error) -> Void

private let apiUrl = "http://librsv.korea.ac.kr/DLMS_KOU_INTRO/api/seatStatusList.do"

public extension kuStudy {
    public class func startFecthingData(autoUpdate: Bool = false) {
        DataManager.shared.startFetching(autoUpdate: autoUpdate)
    }
    
    public class func requestUpdateData() {
        DataManager.shared.requestUpdate()
    }
    
    public class func stopFetchingData() {
        DataManager.shared.stopFetching()
    }
}

public extension kuStudy {
    public static let didUpdateDataNotification = Notification.Name(rawValue: "kuStudyKit.DataManager.Notification.DidUpdate")
    
    public class var summaryData: SummaryData? { return DataManager.shared.summaryData }
    public class var libraryData: [LibraryData]? { return DataManager.shared.libraryData }
    public class var errors: [Error]? { return DataManager.shared.errors }
    
    public class var lastUpdatedAt: Date? { return DataManager.shared.lastUpdatedAt }
    
    public class func libraryData(for library: LibraryType) -> LibraryData? {
        return libraryData?.filter({ $0.libraryType == library }).first
    }
}

public extension kuStudy {
    @available(*, deprecated: 1.0)
    public class func requestSummaryData(onLibrarySuccess: ((_ libraryData: LibraryData) -> ())?, onFailure: FailureHandler?, onCompletion: ((_ summaryData: SummaryData) -> ())?) {
        let libraryTypes = LibraryType.allTypes()
        var completeCount = 0
        let summaryData = SummaryData()
        for type in libraryTypes {
            let libraryId = type.rawValue
            requestLibraryData(libraryId: "\(libraryId)",
               onSuccess: { (libraryData) in
                    onLibrarySuccess?(libraryData)
                    summaryData.libraries.append(libraryData)
                    completeCount += 1
                    if completeCount == libraryTypes.count {
                        onCompletion?(summaryData)
                    }
                },
               onFailure: { (error) in
                    onFailure?(error)
                    completeCount += 1
                    if completeCount == libraryTypes.count {
                        onCompletion?(summaryData)
                    }
            })
        }
    }
    
    @available(*, deprecated: 1.0)
    public class func requestLibraryData(libraryId: String, onSuccess: @escaping (_ libraryData: LibraryData) -> (), onFailure: FailureHandler?) {
        Alamofire.request("https://librsv.korea.ac.kr/libraries/lib-status/" + libraryId, method: .get)
            .responseObject { (response: DataResponse<LibraryData>) in
                switch response.result {
                case .success(let libraryData):
                    libraryData.libraryId = libraryId
                    onSuccess(libraryData)
                case .failure(let error):
                    onFailure?(error)
                }
        }
    }
}
