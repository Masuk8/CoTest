//
//  LoginRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class LoginRequestStepBuilder {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    fileprivate let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension LoginRequestStepBuilder: LoginRequestStepBuilderType {
    
    func with(email: String, password: String) -> RequestBuilder<Void, LoginError> {
        return EmailPasswordLoginRequestBuilder(email: email, password: password, dependencies: dependencies)
    }
    
    var silently: RequestBuilder<Void, LoginSilentlyError> {
        return ExistingSessionLoginRequestBuilder(dependencies: dependencies)
    }
}
