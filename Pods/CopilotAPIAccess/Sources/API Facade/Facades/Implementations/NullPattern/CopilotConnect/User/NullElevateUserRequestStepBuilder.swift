//
//  NullElevateUserRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 28/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullElevateUserRequestStepBuilder: ElevateUserRequestStepBuilderType {
    
    func with(email: String, password: String, firstname: String, lastname: String) -> RequestBuilder<Void, ElevateAnonymousUserError> {
        return NullRequestBuilder<Void, ElevateAnonymousUserError>()
    }
    
}
