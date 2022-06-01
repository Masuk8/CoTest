//
//  NullLoginRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 29/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullLoginRequestStepBuilder: LoginRequestStepBuilderType {
    
    func with(email: String, password: String) -> RequestBuilder<Void, LoginError> {
        return NullRequestBuilder<Void, LoginError>()
    }
    
    var silently: RequestBuilder<Void, LoginSilentlyError> = NullRequestBuilder<Void, LoginSilentlyError>()
    
}
