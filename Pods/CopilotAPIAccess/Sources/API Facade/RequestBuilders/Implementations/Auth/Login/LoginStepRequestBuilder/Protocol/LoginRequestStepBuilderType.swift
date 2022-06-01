//
//  LoginRequestStepBuilderType.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public protocol LoginRequestStepBuilderType {
    /// Uses basic email/password authentication.
    func with(email: String, password: String) -> RequestBuilder<Void, LoginError>
    
    /// Authenticates using the current session, used for silent login.
    var silently: RequestBuilder<Void,LoginSilentlyError> { get }
}
