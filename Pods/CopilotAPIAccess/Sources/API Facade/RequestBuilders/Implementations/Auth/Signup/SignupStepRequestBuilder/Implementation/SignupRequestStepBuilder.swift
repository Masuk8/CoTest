//
//  SignupRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class SignupRequestStepBuilder {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    fileprivate let dependencies: Dependencies
    
    fileprivate var consents: [String: Bool]
    
    init(consents: [String: Bool], dependencies: Dependencies) {
        self.consents = consents
        self.dependencies = dependencies
    }
}

extension SignupRequestStepBuilder: SignupGDPRCompliantRequestStepBuilderType {
    
    func with(email: String, password: String, firstname: String, lastname: String) -> RequestBuilder<Void, SignupError> {
        return EmailSignupRequestBuilder(consents: consents, email: email, password: password, firstname: firstname, lastname: lastname, dependencies: dependencies)
    }
    
    var anonymously: RequestBuilder<Void, SignupAnonymouslyError> {
        return AnonymousSignupRequestBuilder(consents: consents, dependencies: dependencies)
    }
    
    func withCustomConsent(_ consentName: String, value: Bool) -> SignupGDPRCompliantRequestStepBuilderType {
        consents[consentName] = value
        return self
    }
}

