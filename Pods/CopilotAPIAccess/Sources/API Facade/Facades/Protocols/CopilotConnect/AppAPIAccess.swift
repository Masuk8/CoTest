//
//  AppFacade.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public protocol AppAPIAccess: class {
    /// Fetch application configuration which includes the terms of use, privacy policy and faq documents.
    func fetchConfig() -> RequestBuilder<Configuration, FetchConfigurationError>
    
    /// Fetch application password policy, used to validate password length and complexity before registering a new user.
    func fetchPasswordPolicyConfig() -> RequestBuilder<[PasswordRule], FetchPasswordRulesPolicyError>
    
    /// Check for current application status, used to know if an upgrade is required.
    func checkAppVersionStatus() -> RequestBuilder<AppVersionStatus, CheckAppVersionStatusError>
}
