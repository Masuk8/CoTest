//
//  ResetPasswordRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class ResetPasswordRequestExecuter: RequestExecuter<Void, ResetPasswordError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction
    private let dependencies: Dependencies
    
    private let email: String
    
    init(email: String, dependencies: Dependencies) {
        self.email = email
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<Void, ResetPasswordError>) -> Void) {
        dependencies.authenticationServiceInteraction.requireResetPassword(withEmail: email, closure: closure)
    }
}
