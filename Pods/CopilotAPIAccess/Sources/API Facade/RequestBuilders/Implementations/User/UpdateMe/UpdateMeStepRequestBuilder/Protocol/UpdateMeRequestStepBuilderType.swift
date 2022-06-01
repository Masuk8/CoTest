//
//  UpdateMeRequestStepBuilderType.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public typealias UpdateMeDetailsRequestBuilderType = UpdateMeRequestStepBuilderType & RequestBuilder<UserMe, UpdateUserDetailsError>

public protocol UpdateMeRequestStepBuilderType {
    /// Update use's firstname, can be chained with others or can call build.
    func with(firstname: String) -> UpdateMeDetailsRequestBuilderType
    
    /// Update user's lastname, can be chained with others or can call build.
    func with(lastname: String) -> UpdateMeDetailsRequestBuilderType
    
    /// Update user's single custom setting by passing its name and value, can be chained with others or can call build.        
    func with<T: Encodable>(customValue value: T, forKey key: String) -> UpdateMeDetailsRequestBuilderType
    
    /// Remove a specific value for the received key from the user's custom settings, can be chained with others or can call build.
    func removeCustomValue(forKey key: String) -> UpdateMeDetailsRequestBuilderType
}
