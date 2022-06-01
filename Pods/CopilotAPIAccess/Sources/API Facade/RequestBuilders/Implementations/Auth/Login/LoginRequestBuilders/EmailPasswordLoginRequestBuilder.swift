//
//  EmailPasswordLoginRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class EmailPasswordLoginRequestBuilder: RequestBuilder<Void, LoginError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    private let dependencies: Dependencies
    
    private let email: String
    private let password: String
    
    init(email: String, password: String, dependencies: Dependencies) {
        self.email = email
        self.password = password
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Void, LoginError> {
        return EmailPasswordLoginRequestExecuter(email: email, password: password, dependencies: dependencies)
    }
}
