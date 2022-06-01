//
//  FetchThingRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class FetchThingRequestExecuter: RequestExecuter<Thing, FetchSingleThingError> {
    
    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    private let physicalId: String
    
    init(physicalId: String, dependencies: Dependencies) {
        self.physicalId = physicalId
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<Thing, FetchSingleThingError>) -> Void) {
        dependencies.thingsServiceInteraction.getAssociatedSingleThing(physicalID: physicalId, getThingClosure: closure)
    }
}
