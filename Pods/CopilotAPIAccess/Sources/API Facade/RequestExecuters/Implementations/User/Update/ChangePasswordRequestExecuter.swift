//
//  ChangePassowrdRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Adaya on 07/03/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
//

class ChangePasswordRequestExecuter: RequestExecuter<Void, ChangePasswordError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction
    private let dependencies: Dependencies
    
    private let newPassword: String
    private let oldPassword: String
    
    init(newPassword: String, oldPassword: String, dependencies: Dependencies) {
        self.newPassword = newPassword
        self.oldPassword = oldPassword
        self.dependencies = dependencies
    }
    
    
    override func execute(_ closure: @escaping (Response<Void, ChangePasswordError>) -> Void) {
        dependencies.authenticationServiceInteraction.changePassword(newPassword: newPassword, oldPassword: oldPassword, closure: closure)
    }
}
