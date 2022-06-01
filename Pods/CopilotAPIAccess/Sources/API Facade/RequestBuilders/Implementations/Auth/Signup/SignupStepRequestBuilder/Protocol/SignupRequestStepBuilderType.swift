//
//  SignupRequestStepBuilderType.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public protocol SignupRequestStepBuilderType {
    /// Registers a user with email and password
    func with(email: String, password: String, firstname: String, lastname: String) -> RequestBuilder<Void, SignupError>
    
    /// Registers a user anonymously
    var anonymously: RequestBuilder<Void, SignupAnonymouslyError> { get }
}

public protocol SignupGDPRCompliantRequestStepBuilderType: SignupRequestStepBuilderType {
    /// Add custom consents as part of the registration info.
    func withCustomConsent(_ consentName: String, value: Bool) -> SignupGDPRCompliantRequestStepBuilderType
}
