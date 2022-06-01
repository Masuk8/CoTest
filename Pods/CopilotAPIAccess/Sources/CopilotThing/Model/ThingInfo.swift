//
//  ThingInfo.swift
//  Things
//
//  Created by Yulia Felberg on 29/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public struct ThingInfo {
    
    public var name: String?
    public let firmware: String
    public let model: String
    public let physicalId: String
    
    fileprivate struct Constants {
        static let nameKey = "name"
        static let firmwareKey = "firmware"
        static let modelKey = "model"
        static let physicalIdKey = "physicalId"
    }
    
    public init?(withDictionary dictionary: [String: Any]) {
        
        //Mandatory
        
        guard let firmware = dictionary[Constants.firmwareKey] as? String else {
            ZLogManagerWrapper.sharedInstance.logError(message: "unable to create ThingInfo from dictionary. firmware is missing")
            return nil
        }
        
        guard let model = dictionary[Constants.modelKey] as? String else {
            ZLogManagerWrapper.sharedInstance.logError(message: "unable to create ThingInfo from dictionary. model is missing")
            return nil
        }
        
        guard let physicalID = dictionary[Constants.physicalIdKey] as? String else {
            ZLogManagerWrapper.sharedInstance.logError(message: "unable to create ThingInfo from dictionary. physicalID is missing")
            return nil
        }
        
        self.firmware = firmware
        self.model = model
        self.physicalId = physicalID
        
        //Optional
        
        if let name = dictionary[Constants.nameKey] as? String {
            self.name = name
        }
        else {
            ZLogManagerWrapper.sharedInstance.logWarning(message: "ThingInfo name param is missing")
        }
    }
}

extension ThingInfo: CustomStringConvertible {
    
    public var description: String {
        return "\(Constants.nameKey):\(String(describing: name)), \(Constants.firmwareKey): \(String(describing: firmware)), \(Constants.modelKey): \(String(describing: model)), \(Constants.physicalIdKey): \(String(describing: physicalId))"
    }
}
