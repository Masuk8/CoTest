//
//  AuthAPI.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 18/11/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class AuthAPI: AuthAPIAccess {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    private let dependencies: Dependencies
        
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func signup() -> SignupConsentsRequestStepBuilderType {
        return SignupConsentsRequestStepBuilder(dependencies: dependencies)
    }
    
    func login() -> LoginRequestStepBuilderType {
        return LoginRequestStepBuilder(dependencies: dependencies)
    }
    
    func logout() -> LogoutRequestBuilderType {
        return LogoutRequestBuilder(dependencies: dependencies)
    }
    
}
