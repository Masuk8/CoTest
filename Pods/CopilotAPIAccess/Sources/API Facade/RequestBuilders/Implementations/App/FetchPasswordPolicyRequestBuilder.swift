//
//  FetchPasswordPolicyRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class FetchPasswordPolicyRequestBuilder: RequestBuilder<[PasswordRule], FetchPasswordRulesPolicyError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<[PasswordRule], FetchPasswordRulesPolicyError> {
        return FetchPasswordPolicyRequestExecuter(dependencies: dependencies)
    }
}
