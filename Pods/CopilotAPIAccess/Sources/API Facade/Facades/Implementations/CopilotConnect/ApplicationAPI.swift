//
//  App.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class ApplicationAPI: AppAPIAccess {

    typealias Dependencies = HasAuthenticationServiceInteraction & HasSystemConfigurationServiceInteraction & HasConfigurationProvider
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func fetchConfig() -> RequestBuilder<Configuration, FetchConfigurationError> {
        return FetchConfigRequestBuilder(dependencies: dependencies)
    }
    
    func fetchPasswordPolicyConfig() -> RequestBuilder<[PasswordRule], FetchPasswordRulesPolicyError> {
        return FetchPasswordPolicyRequestBuilder(dependencies: dependencies)
    }
    
    func checkAppVersionStatus() -> RequestBuilder<AppVersionStatus, CheckAppVersionStatusError> {
        return CheckAppVersionRequestBuilder(appVersion: dependencies.configurationProvider.appVersion, dependencies: dependencies)
    }    
    
}
