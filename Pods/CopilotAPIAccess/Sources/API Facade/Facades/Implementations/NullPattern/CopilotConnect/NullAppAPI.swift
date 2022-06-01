//
//  NullAppAPI.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 23/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullAppAPI: AppAPIAccess {
    
    func fetchConfig() -> RequestBuilder<Configuration, FetchConfigurationError> {
        return NullRequestBuilder<Configuration, FetchConfigurationError>()
    }
    
    func fetchPasswordPolicyConfig() -> RequestBuilder<[PasswordRule], FetchPasswordRulesPolicyError> {
        return NullRequestBuilder<[PasswordRule], FetchPasswordRulesPolicyError>()
    }
    
    func checkAppVersionStatus() -> RequestBuilder<AppVersionStatus, CheckAppVersionStatusError> {
        return NullRequestBuilder<AppVersionStatus, CheckAppVersionStatusError>()
    }
}
