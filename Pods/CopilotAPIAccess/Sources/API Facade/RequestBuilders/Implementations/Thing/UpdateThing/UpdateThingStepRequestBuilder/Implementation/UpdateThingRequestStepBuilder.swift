//
//  UpdateThingRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

class UpdateThingRequestStepBuilder: RequestBuilder<Thing, UpdateThingError> {
    
    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    private let physicalId: String
    fileprivate var firmware: String?
    fileprivate var name: String?
    fileprivate var customSettings: [String : Any] = [:]
    fileprivate var status: ThingStatus?
    private var error: UpdateThingError? = nil
    
    init(physicalId: String, dependencies: Dependencies) {
        self.physicalId = physicalId
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Thing, UpdateThingError> {
        return UpdateThingRequestExecuter(physicalId: physicalId,
                                          firmware: firmware,
                                          name: name,
                                          customSettings: customSettings,
                                          status: status,
                                          error: error,
                                          dependencies: dependencies)
    }
}

extension UpdateThingRequestStepBuilder: UpdateThingRequestStepBuilderType {
    
    public func with(firmware: String) -> UpdateThingRequestBuilderType {
        self.firmware = firmware
        return self
    }
    
    public func with(name: String) -> UpdateThingRequestBuilderType {
        self.name = name
        return self
    }    
    
    func with<T: Encodable>(customValue value: T, forKey key: String) -> UpdateThingRequestBuilderType {
        do {
            let data = try JSONEncoder().encode([key : value])
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                customSettings[key] = json[key]
            }
        } catch {
            let updateThingError = UpdateThingError.invalidParameters(debugMessage: "failed to add custom settings value - \(value) key - \(key) with error: \(error)")
            self.error = updateThingError
            ZLogManagerWrapper.sharedInstance.logError(message: "failed to add custom settings value - \(value) key - \(key) with error: \(error)")
        }
        
        return self
    }
    
    func removeCustomValue(forKey key: String) -> UpdateThingRequestBuilderType {
        customSettings.unsetValue(forKey: key)
        return self
    }
    
    public func with(status: ThingStatus) -> UpdateThingRequestBuilderType {
        self.status = status
        return self
    }
}
