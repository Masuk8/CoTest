//
//  AssociateThingRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class AssociateThingRequestExecuter: RequestExecuter<Thing, AssociateThingError> {
    
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
    
    override func execute(_ closure: @escaping (Response<Thing, AssociateThingError>) -> Void) {
        dependencies.thingsServiceInteraction.associateThing(firmware: firmware, model: model, physicalID: physicalID, associateThingClosure: closure)
    }
}
