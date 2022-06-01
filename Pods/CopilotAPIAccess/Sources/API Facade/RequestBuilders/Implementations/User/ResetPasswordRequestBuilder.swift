//
//  ResetPasswordRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class ResetPasswordRequestBuilder: RequestBuilder<Void, ResetPasswordError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction
    private let dependencies: Dependencies
    
    private let email: String
    
    init(email: String, dependencies: Dependencies) {
        self.email = email
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Void, ResetPasswordError> {
        return ResetPasswordRequestExecuter(email: email, dependencies: dependencies)
    }
}
