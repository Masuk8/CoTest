//
//  UpdateThingRequestBuilderType.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public typealias UpdateThingRequestBuilderType = UpdateThingRequestStepBuilderType & RequestBuilder<Thing, UpdateThingError>

public protocol UpdateThingRequestStepBuilderType {
    /// Update thing firmware, can be chained by others calls, or can call build right after.
    func with(firmware: String) -> UpdateThingRequestBuilderType
    
    /// Update thing's name, can be chained by others calls, or can call build right after.
    func with(name: String) -> UpdateThingRequestBuilderType
    
    /// Update thing's custom settings, can be chained by others calls, or can call build right after.    
    func with<T: Encodable>(customValue value: T, forKey key: String) -> UpdateThingRequestBuilderType
    
    /// Remove a specific value for the received key from the thing's custom settings, can be chained with others or can call build.
    func removeCustomValue(forKey key: String) -> UpdateThingRequestBuilderType
    
    /// Update thing's status, can be chained by others calls, or can call execute() right after.
    func with(status: ThingStatus) -> UpdateThingRequestBuilderType
}
