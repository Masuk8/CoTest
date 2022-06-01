//
//  ThingServiceParamsInterpreter.swift
//  Thing
//
//  Created by Tom Milberg on 10/06/2018.
//  Copyright © 2018 Falcore. All rights reserved.
//

import Foundation

struct ThingServiceParamsInterpreter {
    
    private struct Constants {
        static let itemIdKey = "info"
        static let thingsKey = "things"
        static let firmwareKey = "firmware"
        static let modelKey = "model"
        static let physicalIDKey = "physicalId"
        static let customSettingsKey = "customSettings"
        static let nameKey = "name"
        static let statusKey = "status"
    }
    
    static func convertGetThingParamsToDictionary(thingID: String) -> [String: Any] {
        return [Constants.itemIdKey : thingID]
    }
    
    static func convertCanAssociateThingParamsToDictionary(thingID: String) -> [String: Any] {
        return [Constants.physicalIDKey : thingID]
    }
    
    static func convertAssociateThingParamsToDictionary(firmware: String, model: String, physicalID: String) -> [String: Any] {
        return [Constants.firmwareKey : firmware, Constants.modelKey : model, Constants.physicalIDKey : physicalID]
    }
    
    static func convertUpdateThingParamsToDictionary(firmware: String?, name: String?, customSettings: [String:Any]?, thingStatus: ThingStatus?) -> [String:Any] {
        var parameters = [String: Any]()
        
        if let firmware = firmware {
            parameters[Constants.firmwareKey] = firmware
        }

        if let name = name {
            parameters[Constants.nameKey] = name
        }

        if let customSettings = customSettings {
            parameters[Constants.customSettingsKey] = customSettings
        }
        
        if let thingStatus = thingStatus {
            parameters[Constants.statusKey] = thingStatus.toDictionary()
        }

        return parameters
    }
    
    static func getThingsArrayFromDictionary(thingsDictionary: [String:Any]) -> [[String : Any]]? {
        
        var things: [[String : Any]]? = nil
        
        if let thingsArray = thingsDictionary[Constants.thingsKey] as? [[String : Any]] {
            things = thingsArray
        }
        
        return things
    }
}
