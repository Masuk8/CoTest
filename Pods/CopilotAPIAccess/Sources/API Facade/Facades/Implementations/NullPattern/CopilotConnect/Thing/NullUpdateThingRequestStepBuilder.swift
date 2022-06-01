//
//  NullUpdateThingRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 29/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

typealias NullUpdateThingRequestBuilderType = UpdateThingRequestStepBuilderType & NullRequestBuilder<Thing, UpdateThingError>

class NullUpdateThingRequestStepBuilder: NullUpdateThingRequestBuilderType {

    func with(firmware: String) -> UpdateThingRequestBuilderType {
        return self
    }
    
    func with(name: String) -> UpdateThingRequestBuilderType {
        return self
    }
    
    func with<T>(customValue value: T, forKey key: String) -> UpdateThingRequestBuilderType where T : Encodable {
        return self
    }
    
    func removeCustomValue(forKey key: String) -> UpdateThingRequestBuilderType {
        return self
    }
    
    func with(status: ThingStatus) -> UpdateThingRequestBuilderType {
        return self
    }
    
}
