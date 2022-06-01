//
//  ThingStatus.swift
//  CopilotThing
//
//  Created by Tom Milberg on 11/06/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public struct ThingStatus {
    
    public let lastSeen: Date
    public let reportedStatuses: [ThingReportedStatus]
    
    private struct Constants {
        static let lastSeenKey = "lastSeen"
        static let statusesKey = "statuses"
        static let reportedKey = "reportedStatus"
    }
    
    public var description: String {
        return "\(Constants.lastSeenKey):\(String(describing: lastSeen)), \(Constants.statusesKey): \(String(describing: reportedStatuses))"
    }
    
    public init(lastSeen: Date, reportedStatuses: [ThingReportedStatus]) {
        self.lastSeen = lastSeen
        self.reportedStatuses = reportedStatuses
    }

    public init?(withDictionary dictionary: [String: Any]) {
        guard let lastSeen = dictionary[Constants.lastSeenKey] as? Double else {
            ZLogManagerWrapper.sharedInstance.logWarning(message: "unable to create ThingStatus from dictionary. Last seen value is missing")
            return nil
        }
        
        if let thingReportedStatuses = dictionary[Constants.statusesKey] as? [[String : Any]] {
            var reportedStatusesArray = [ThingReportedStatus]()
            
            thingReportedStatuses.forEach({ (reportedStatusDict) in
                if let reportedStatus = ThingReportedStatus(withDictionary: reportedStatusDict) {
                    reportedStatusesArray.append(reportedStatus)
                }
            })
            
            self.reportedStatuses = reportedStatusesArray
        } else {
            self.reportedStatuses = [ThingReportedStatus]()
        }
        
        // Fixed previous bug AOTP-2825 which the last seen time was saved in seconds instead of millisecods, backward compatible supported for the last seen time that was saved in seconds.
        if lastSeen < ThingConsts.minimumSupportedEpoch {
            self.lastSeen = Date.init(timeIntervalSince1970: lastSeen)
        } else {
            let lastSeenInSeconds = lastSeen / 1000
            self.lastSeen = Date.init(timeIntervalSince1970: lastSeenInSeconds)
        }
    }
    
    internal func toDictionary() -> [String:Any] {
        
        // Last seen time should be always sent in miliseconds.
        var thingStatusDict: [String:Any] = [Constants.lastSeenKey: lastSeen.timeIntervalSince1970 * 1000]
        
        var reportedStatusesDictionaryArray = [[String:Any]]()
        
        reportedStatuses.forEach({ (thingReportedStatus) in
            reportedStatusesDictionaryArray.append(thingReportedStatus.toDictionary())
        })
        
        thingStatusDict[Constants.reportedKey] = reportedStatusesDictionaryArray
        
        return thingStatusDict
    }
}

extension ThingStatus: Equatable {
    
    public static func == (lhs: ThingStatus, rhs: ThingStatus) -> Bool {        
        return lhs.lastSeen == rhs.lastSeen && lhs.reportedStatuses == rhs.reportedStatuses
    }
}
