//
//  ThingFacade.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public protocol ThingAPIAccess: class {
    /// Fetch all the associated things
    func fetchThings() -> RequestBuilder<[Thing], FetchThingsError>
    
    /// Fetch a thing passing its id (serial number or physicalId)
    ///
    /// - Parameter physicalId: The serial number or physical ID of the thing
    ///
    func fetchThing(withPhysicalId physicalId: String) -> RequestBuilder<Thing, FetchSingleThingError>
    
    /// Update a thing passing its id (serial number or physicalId)
    ///
    /// - Parameter physicalId: The serial number or physical ID of the thing
    func updateThing(withPhysicalId physicalId: String) -> UpdateThingRequestStepBuilderType
    
    /// Associate a thing to the current user
    func associateThing(withPhysicalId physicalID: String, firmware: String, model: String) -> RequestBuilder<Thing, AssociateThingError>
    
    /// Disassociate a thing to the current user
    ///
    /// - Parameter physicalId: The serial number or physical ID of the thing
    func disassociateThing(withPhysicalId physicalId: String) -> RequestBuilder<Void, DisassociateThingError>
    
    
    /// Proactively check if association will be successfull. Use this is you need to determine if association is allowed before allowing the user to even attempt accessing the device
    ///
    /// - Parameter physicalId: The serial number or physical ID of the thing
    func checkIfCanAssociate(withPhysicalId physicalID: String) -> RequestBuilder<CanAssociateResponse, CanAssociateThingError>
}
