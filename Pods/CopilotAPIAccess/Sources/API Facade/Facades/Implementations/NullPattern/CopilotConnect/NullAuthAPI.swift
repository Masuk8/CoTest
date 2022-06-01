//
//  NullAuthAPI.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 24/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullAuthAPI: AuthAPIAccess {
    
    func signup() -> SignupConsentsRequestStepBuilderType {
        return NullSignupConsentsRequestStepBuilder()
    }
    
    func login() -> LoginRequestStepBuilderType {
        return NullLoginRequestStepBuilder()
    }
    
    func logout() -> LogoutRequestBuilderType {
        return NullLogoutRequestBuilder()
    }
}
