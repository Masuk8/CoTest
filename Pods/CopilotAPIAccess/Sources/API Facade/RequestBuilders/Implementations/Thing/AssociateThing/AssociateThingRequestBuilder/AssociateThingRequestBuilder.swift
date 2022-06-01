//
//  AssociateThingRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class AssociateThingRequestBuilder: RequestBuilder<Thing, AssociateThingError> {
    
    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    private let physicalID: String
    private let firmware: String
    private let model: String
    
    init(physicalID: String, firmware: String, model: String, dependencies: Dependencies) {
        self.physicalID = physicalID
        self.firmware = firmware
        self.model = model
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Thing, AssociateThingError> {
        return AssociateThingRequestExecuter(physicalID: physicalID, firmware: firmware, model: model, dependencies: dependencies)
    }
}
