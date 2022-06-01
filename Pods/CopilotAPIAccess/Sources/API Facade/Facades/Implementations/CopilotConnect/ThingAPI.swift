//
//  ThingAPI.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import UIKit

class ThingAPI: ThingAPIAccess {

    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func fetchThings() -> RequestBuilder<[Thing], FetchThingsError> {
        return FetchThingsRequestBuilder(dependencies: dependencies)
    }
    
    func fetchThing(withPhysicalId physicalId: String) -> RequestBuilder<Thing, FetchSingleThingError> {
        return FetchThingRequestBuilder(physicalId: physicalId, dependencies: dependencies)
    }
    
    func updateThing(withPhysicalId physicalId: String) -> UpdateThingRequestStepBuilderType {
        return UpdateThingRequestStepBuilder(physicalId: physicalId, dependencies: dependencies)
    }
    
    func associateThing(withPhysicalId physicalID: String, firmware: String, model: String) -> RequestBuilder<Thing, AssociateThingError> {
        return AssociateThingRequestBuilder(physicalID: physicalID, firmware: firmware, model: model, dependencies: dependencies)
    }
    
    func disassociateThing(withPhysicalId physicalId: String) -> RequestBuilder<Void, DisassociateThingError> {
        return DisassociateThingRequestBuilder(physicalID: physicalId, dependencies: dependencies)
    }
    
    func checkIfCanAssociate(withPhysicalId physicalID: String) -> RequestBuilder<CanAssociateResponse, CanAssociateThingError> {
        return CanAssociateThingRequestBuilder(physicalID: physicalID, dependencies: dependencies)
    }
    

}
