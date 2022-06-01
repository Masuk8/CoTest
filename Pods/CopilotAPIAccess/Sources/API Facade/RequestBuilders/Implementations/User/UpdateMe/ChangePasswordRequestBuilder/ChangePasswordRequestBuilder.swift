//
//  ChangePasswordRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Adaya on 07/03/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class ChangePasswordRequestBuilder: RequestBuilder<Void, ChangePasswordError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction
    private let dependencies: Dependencies
    
    private let newPassword: String
    private let oldPassword: String
    
    init(newPassword: String, oldPassword: String, dependencies: Dependencies) {
        self.newPassword = newPassword
        self.oldPassword = oldPassword
        self.dependencies = dependencies
    }
    
    override func build() -> RequestExecuter<Void, ChangePasswordError> {
        return ChangePasswordRequestExecuter(newPassword: newPassword, oldPassword: oldPassword, dependencies: dependencies)
    }
}
