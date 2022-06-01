//
//  ElevateUserRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 10/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class ElevateUserRequestBuilder: RequestBuilder<Void, ElevateAnonymousUserError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    private let dependencies: Dependencies
    
    private let email: String
    private let password: String
    private let firstname: String
    private let lastname: String
    
    init(email: String, password: String, firstname: String, lastname: String, dependencies: Dependencies) {
        self.email = email
        self.password = password
        self.firstname = firstname
        self.lastname = lastname
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Void, ElevateAnonymousUserError> {
        return ElevateUserRequestExecuter(email: email, password: password, firstname: firstname, lastname: lastname, dependencies: dependencies)
    }
}
