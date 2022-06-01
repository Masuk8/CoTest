//
//  Thing.swift
//  Things
//
//  Created by Yulia Felberg on 29/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public struct Thing {
    
    public enum Constants {
        static let idKey = "id"
        static let infoKey = "info"
        static let customSettingsKey = "customSettings"
        static let statusKey = "status"
    }
    
    fileprivate let id: String
    public var thingInfo: ThingInfo
    let serializedCustomSettings: [String: Any]?
    public var customSettingsKeys: [String]? {
        return serializedCustomSettings?.keys.map({ return $0 })
    }
    public var thingStatus: ThingStatus?
    
    // MARK: - Init
    
    init?(withDictionary dictionary: [String: Any]) {
        guard let idString = dictionary[Constants.idKey] as? String, let thingInfoDictionary = dictionary[Constants.infoKey] as? [String: Any], let thingInfo = ThingInfo(withDictionary: thingInfoDictionary) else {
            
            ZLogManagerWrapper.sharedInstance.logError(message: "Not creating Thing because of insufficient data in dictionary: \(dictionary)")
            return nil
        }
        
        id = idString
        self.thingInfo = thingInfo
        
        serializedCustomSettings = dictionary[Constants.customSettingsKey] as? [String: Any]
        if serializedCustomSettings == nil {
            ZLogManagerWrapper.sharedInstance.logInfo(message: "No customSettings for thing id: " + id)
        }
        
        thingStatus = initThingStatusFromDictionary(dictionary)        
    }
    
    // MARK: - Private

    private func initThingStatusFromDictionary(_ dictionary: [String: Any]) -> ThingStatus? {
        if let thingStatusDict = dictionary[Constants.statusKey] as? [String: Any] {
            if let thingStatus = ThingStatus(withDictionary: thingStatusDict) {
                return thingStatus
            }
            else {
                ZLogManagerWrapper.sharedInstance.logError(message: "Failed to create ThingStatus from dictionary")
                return nil
            }
        }
        else {
            ZLogManagerWrapper.sharedInstance.logInfo(message: "No ThingStatus or it's not a dictionary")
            return nil
        }
    }
    
    // MARK: - Public
    
    public func get<T: Decodable>(key: String, as objectType: T.Type) -> T? {
        guard let val = serializedCustomSettings?[key], !(val is NSNull) else {
            return nil
        }
        
        if val is T {
            return val as? T
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: val, options: [])
            let t = try JSONDecoder().decode(objectType, from: data)
            return t
        } catch {
            ZLogManagerWrapper.sharedInstance.logError(message: "Failed to decode data for key with error \(error)")
            return nil
        }
    }
    
}

extension Thing: CustomStringConvertible {
    
    public var description: String {
        return "id: \(id); thingInfo: \(String(describing: thingInfo)); customSettings: \(String(describing: serializedCustomSettings))"
    }
}
