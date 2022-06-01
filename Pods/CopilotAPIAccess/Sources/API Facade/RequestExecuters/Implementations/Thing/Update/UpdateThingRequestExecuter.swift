//
//  UpdateThingRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class UpdateThingRequestExecuter: RequestExecuter<Thing, UpdateThingError> {
    
    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    private let physicalId: String
    private var firmware: String?
    private var name: String?
    private var customSettings: [String: Any]
    private var status: ThingStatus?
    private let error: UpdateThingError?
    
    init(physicalId: String,
         firmware: String?,
         name: String?,
         customSettings: [String: Any],
         status: ThingStatus?,
         error: UpdateThingError?,
         dependencies: Dependencies) {
        
        self.physicalId = physicalId
        self.firmware = firmware
        self.name = name
        self.customSettings = customSettings
        self.status = status
        self.error = error
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<Thing, UpdateThingError>) -> Void) {
        if let error = self.error {
            closure(.failure(error: error))
        } else {
            let customSettings = self.customSettings.isEmpty ? nil : self.customSettings
            dependencies.thingsServiceInteraction.updateAssociatedThing(physicalID: physicalId, firmware: firmware, name: name, customSettings: customSettings, thingStatus: status, updateThingClosure: closure)
        }
    }
}
