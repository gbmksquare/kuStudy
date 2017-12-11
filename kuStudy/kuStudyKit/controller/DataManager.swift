//
//  DataManager.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 20..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

internal class DataManager {
    internal static let shared = DataManager()
    
    private var group: DispatchGroup?
    
    // Fetched data
    internal var summaryData: SummaryData?
    internal var libraryData: [LibraryData]?
    internal var errors: [Error]?
    
    // Update
    private var timer: Timer?
    private var shouldAutoUpdate = false
    private var updateInterval: TimeInterval = 60
    internal var lastUpdatedAt: Date?
    
    // MARK: - Initialization
    private init() {
        libraryData = [LibraryData]()
    }
    
    // MARK: - Fetch (Internal)
    internal func startFetching(autoUpdate: Bool? = nil, updateInterval: TimeInterval? = nil) {
        if let updateInterval = updateInterval {
            self.updateInterval = updateInterval
        }
        if let autoUpdate = autoUpdate {
            self.shouldAutoUpdate = autoUpdate
        }
        if self.shouldAutoUpdate == true {
            requestAllData()
            timer = Timer.scheduledTimer(timeInterval: self.updateInterval,
                                         target: self,
                                         selector: #selector(handle(timer:)),
                                         userInfo: nil,
                                         repeats: true)
        } else {
            requestAllData()
        }
    }
    
    internal func requestUpdate() {
        guard let lastUpdatedAt = lastUpdatedAt else {
            requestAllData()
            return
        }
        let interval = Date().timeIntervalSince(lastUpdatedAt)
        if interval > 60 {
            requestAllData()
        }
    }
    
    internal func stopFetching() {
        timer?.invalidate()
        timer = nil
    }
    
    internal func enableAutoUpdate() {
        shouldAutoUpdate = true
        startFetching()
    }
    
    internal func disableAutoUpdate() {
        shouldAutoUpdate = false
        stopFetching()
    }
    
    internal func update(updateInterval: TimeInterval) {
        self.updateInterval = updateInterval
        stopFetching()
        startFetching()
    }
    
    // MARK: - Fetch (Private)
    @objc private func handle(timer: Timer) {
        requestAllData()
    }
    
    private func requestAllData() {
        let group = DispatchGroup()
        self.group = group
        
        let all = LibraryType.allTypes()
        for library in all {
            requestData(library: library)
        }
        
        group.notify(queue: .main) { [weak self] in
            let data = self?.libraryData ?? [LibraryData]()
            let summary = SummaryData(libraryData: data)
            self?.summaryData = summary
            self?.lastUpdatedAt = Date()
            
            // Notify
            NotificationCenter.default.post(name: kuStudy.didUpdateDataNotification, object: self)
        }
    }
    
    private func requestData(library: LibraryType) {
        group?.enter()
        Alamofire.request(library.apiUrl, method: .get)
            .responseObject { [weak self] (response: DataResponse<LibraryData>) in
                switch response.result {
                case .success(let data):
                    data.libraryId = library.identifier
                    self?.libraryData?.append(data)
                    self?.group?.leave()
                case .failure(let error):
                    self?.errors?.append(error)
                    self?.group?.leave()
                }
        }
    }
}
