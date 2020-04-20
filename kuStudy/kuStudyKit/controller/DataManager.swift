//
//  DataManager.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 20..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import os.log

public class DataManager {
    public static let shared = DataManager()
    
    private var updateInterval: TimeInterval = 60
    public private(set) var updatedAt = Date.distantPast
    private(set) var data = Summary(libraries: []) {
        didSet {
            os_log(.debug, log: .api, "DataManager data updated")
            NotificationCenter.default.post(name: Self.didUpdateNotification, object: self)
        }
    }
    
    // MARK: - Internal
    private var apiGroup: DispatchGroup?
    private var temporaryData: [Library]?
    private var errors: [Error]?
    
    private var timer: Timer?
    
    // MARK: - Notification
    public static let didUpdateNotification = Notification.Name("DataManager.didUpdateNotification")
    
    // MARK: - Initialization
    private init() {
        os_log(.debug, log: .api, "DataManager initialized")
    }
    
    // MARK: - Data getter
    public func summary() -> Summary {
        return data
    }
    
    public func libraryData(for identifier: String) -> Library? {
        return data.libraries.first { $0.type.identifier == identifier }
    }
    
    public func studyAreaData(for identifier: Int, libraryIdentifier: String) -> StudyArea? {
        let library = libraryData(for: libraryIdentifier)
        return library?.studyAreas.first { $0.identifier == identifier }
    }
    
    // MARK: - Data
    public func requestUpdate() {
        os_log(.debug, log: .api, "DataManager request update")
        let intervalSinceLastUpdate = Date().timeIntervalSince(updatedAt)
        if intervalSinceLastUpdate < updateInterval {
            os_log(.info, log: .api, "DataManager updated recently, doing nothing")
            NotificationCenter.default.post(name: Self.didUpdateNotification, object: self)
        } else {
            updateData()
        }
    }
    
    private func updateData() {
        os_log(.debug, log: .api, "DataManager will update data")
        let group = DispatchGroup()
        apiGroup = group
        temporaryData = []
        errors = []
        
        let all = LibraryType.all
        all.forEach {
            updateData(for: $0)
        }
        
        group.notify(queue: .main)
        { [unowned self] in
            self.organizeFetchedData()
        }
    }
    
    private func updateData(for libraryType: LibraryType) {
        os_log(.debug, log: .api, "DataManager request data for %{PUBLIC}@", libraryType.identifier)
        apiGroup?.enter()
        kuStudyAPI.reqeustData(for: libraryType)
        { [unowned self] (result) in
            os_log(.debug, log: .api, "DataManager received response for %{PUBLIC}@", libraryType.identifier)
            switch result {
            case let .success(response):
                self.temporaryData?.append(response)
            case let .failure(error):
                self.errors?.append(error)
            }
            self.apiGroup?.leave()
        }
    }
    
    private func organizeFetchedData() {
        guard let temporaryData = temporaryData else {
            fatalError()
        }
        os_log(.debug, log: .api, "DataManager organizing fetched data with count %{PUBLIC}@", "\(temporaryData.count)")
        
        data = Summary(libraries: temporaryData)
        updatedAt = Date()
        apiGroup = nil
        self.temporaryData = nil
        errors = nil
    }
    
    // MARK: - Auto update
    private func enableAutoUpdate() {
        os_log(.debug, log: .api, "DataManager enable auto update")
        timer = Timer.scheduledTimer(timeInterval: updateInterval,
                                     target: self,
                                     selector: #selector(handle(timer:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func disableAutoUpdate() {
        os_log(.debug, log: .api, "DataManager disable auto update")
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func handle(timer: Timer) {
        requestUpdate()
    }
}
