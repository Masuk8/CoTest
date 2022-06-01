//
//  AnonymousSignupRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import UIKit

class AnonymousSignupRequestBuilder: SignupRequestBuilder<SignupAnonymouslyError> {
    
    override func build() -> RequestExecuter<Void, SignupAnonymouslyError> {
        return AnonymousSignupRequestExecuter(consents: consents, dependencies: dependencies)
    }
}
