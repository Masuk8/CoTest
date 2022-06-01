//
//  NullSignupRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 29/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullSignupRequestStepBuilder: SignupGDPRCompliantRequestStepBuilderType {
    
    func with(email: String, password: String, firstname: String, lastname: String) -> RequestBuilder<Void, SignupError> {
        return NullRequestBuilder<Void, SignupError>()
    }
    
    var anonymously: RequestBuilder<Void, SignupAnonymouslyError> = NullRequestBuilder<Void, SignupAnonymouslyError>()

    func withCustomConsent(_ consentName: String, value: Bool) -> SignupGDPRCompliantRequestStepBuilderType {
        return self
    }
}
