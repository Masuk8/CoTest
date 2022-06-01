//
//  AuthAPIAccess.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 18/11/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public typealias LogoutRequestBuilderType = MarkForDeletionRequestStepBuilderType & RequestBuilder<Void, LogoutError>

public protocol AuthAPIAccess: AnyObject {
    
    /// First step to register a new user
    func signup() -> SignupConsentsRequestStepBuilderType
    
    /// First step to authenticate a user
    func login() -> LoginRequestStepBuilderType
    
    /// Logout from the current session, can be chained by markForDeletion
    func logout() -> LogoutRequestBuilderType
}
