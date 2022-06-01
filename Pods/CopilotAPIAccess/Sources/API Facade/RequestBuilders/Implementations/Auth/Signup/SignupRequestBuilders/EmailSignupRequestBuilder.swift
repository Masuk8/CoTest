//
//  EmailSignupRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import UIKit

class EmailSignupRequestBuilder: SignupRequestBuilder<SignupError> {
    
    private let email: String
    private let password: String
    private let firstname: String
    private let lastname: String
    
    init(consents: [String: Bool],
         email: String,
         password: String,
         firstname: String,
         lastname: String,
         dependencies: Dependencies) {
        self.email = email
        self.password = password
        self.firstname = firstname
        self.lastname = lastname
        super.init(consents: consents, dependencies: dependencies)
    }
    
    override func build() -> RequestExecuter<Void, SignupError> {
        return EmailSignupRequestExecuter(email:email,
                                          password: password,
                                          firstname: firstname,
                                          lastname: lastname,
                                          consents: consents,
                                          dependencies: dependencies)
    }
}
