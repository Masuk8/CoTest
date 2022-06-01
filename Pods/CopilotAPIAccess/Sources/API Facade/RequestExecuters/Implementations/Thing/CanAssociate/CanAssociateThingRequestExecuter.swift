//
//  CanAssociateThingRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Adaya on 23/01/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
class CanAssociateThingRequestExecuter: RequestExecuter<CanAssociateResponse, CanAssociateThingError> {
    
    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    private let physicalID: String
    
    init(physicalID: String, dependencies: Dependencies) {
        self.physicalID = physicalID
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<CanAssociateResponse, CanAssociateThingError>) -> Void) {
        dependencies.thingsServiceInteraction.canAssociateThing(physicalID: physicalID, canAssociateThingClosure: closure)
    }
}
