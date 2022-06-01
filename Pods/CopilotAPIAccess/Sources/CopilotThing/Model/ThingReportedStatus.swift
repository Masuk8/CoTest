//
//  ThingReportedStatus.swift
//  CopilotThing
//
//  Created by Tom Milberg on 11/06/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public struct ThingReportedStatus {
    
    public let time: Date
    public let name: String
    public let value: String
    
    private struct Constants {
        static let timeKey = "date"
        static let nameKey = "name"
        static let valueKey = "statusValue"
    }
    
    public var description: String {
        return "\(Constants.timeKey):\(String(describing: time)), \(Constants.nameKey): \(String(describing: name)), \(Constants.valueKey): \(String(describing: value))"
    }
    
    public init(time: Date, name: String, value: String) {
        self.time = time
        self.name = name
        self.value = value
    }
    
    public init?(withDictionary dictionary: [String: Any]) {
        
        guard let time = dictionary[Constants.timeKey] as? Double else {
            ZLogManagerWrapper.sharedInstance.logWarning(message: "unable to create ThingStatus from dictionary. date value is missing")
            return nil
        }
        
        guard let name = dictionary[Constants.nameKey] as? String else {
            ZLogManagerWrapper.sharedInstance.logWarning(message: "unable to create ThingStatus from dictionary. Name value is missing")
            return nil
        }
        
        guard let value = dictionary[Constants.valueKey] as? String else {
            ZLogManagerWrapper.sharedInstance.logWarning(message: "unable to create ThingStatus from dictionary. StatusValue value is missing")
            return nil
        }
        
        // Fixed previous bug AOTP-2825 which the time was saved in seconds instead of millisecods, backward compatible supported for the time that was saved in seconds.
        if time < ThingConsts.minimumSupportedEpoch {
            self.time = Date.init(timeIntervalSince1970: time)
        } else {
            let timeInSeconds = time / 1000
            self.time = Date.init(timeIntervalSince1970: timeInSeconds)
        }
        
        self.name = name
        self.value = value
    }
    
    internal func toDictionary() -> [String:Any] {
        // Time should be always sent in miliseconds.
        return [Constants.timeKey: time.timeIntervalSince1970 * 1000, Constants.nameKey : name, Constants.valueKey : value]
    }
}

extension ThingReportedStatus: Equatable {
    
    public static func == (lhs: ThingReportedStatus, rhs: ThingReportedStatus) -> Bool {
        return lhs.time == rhs.time && lhs.name == rhs.name && lhs.value == rhs.value
    }
}
