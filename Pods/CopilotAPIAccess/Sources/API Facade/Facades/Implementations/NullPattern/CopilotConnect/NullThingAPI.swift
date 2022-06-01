//
//  NullThingAPI.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 24/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullThingAPI: ThingAPIAccess {
    
    func fetchThings() -> RequestBuilder<[Thing], FetchThingsError> {
        return NullRequestBuilder<[Thing], FetchThingsError>()
    }
    
    func fetchThing(withPhysicalId physicalId: String) -> RequestBuilder<Thing, FetchSingleThingError> {
        return NullRequestBuilder<Thing, FetchSingleThingError>()
    }
    
    func updateThing(withPhysicalId physicalId: String) -> UpdateThingRequestStepBuilderType {
        return NullUpdateThingRequestStepBuilder()
    }
    
    func associateThing(withPhysicalId physicalID: String, firmware: String, model: String) -> RequestBuilder<Thing, AssociateThingError> {
        return NullRequestBuilder<Thing, AssociateThingError>()
    }
    
    func disassociateThing(withPhysicalId physicalId: String) -> RequestBuilder<Void, DisassociateThingError> {
        return NullRequestBuilder<Void, DisassociateThingError>()
    }
    
    func checkIfCanAssociate(withPhysicalId physicalID: String) -> RequestBuilder<CanAssociateResponse, CanAssociateThingError> {
        return NullRequestBuilder<CanAssociateResponse, CanAssociateThingError >()
    }
}
