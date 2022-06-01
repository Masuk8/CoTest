//
//  CanAssociateThingRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Adaya on 23/01/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
//CanAssociateThingRequestBuilder
class CanAssociateThingRequestBuilder : RequestBuilder<CanAssociateResponse, CanAssociateThingError>{
    
    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    private let physicalID: String
    
    init(physicalID: String, dependencies: Dependencies) {
        self.physicalID = physicalID
        self.dependencies = dependencies
    }
    
    override func build() -> RequestExecuter<CanAssociateResponse, CanAssociateThingError> {
        return CanAssociateThingRequestExecuter(physicalID: physicalID, dependencies: dependencies)
    }
}
