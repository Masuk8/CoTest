//
//  UpdateConsentRequestStepBuilderType.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 10/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public typealias UpdateConsentRequestBuilderType = UpdateConsentRequestStepBuilderType & RequestBuilder<Void, UpdateUserConsentError>

public protocol UpdateConsentRequestStepBuilderType {
    
    /// Pass whether or not Copilot should process user data (GDPR compliance).
    func allowCopilotUserAnalysis(_ consent: Bool) -> UpdateConsentRequestBuilderType
    
    /// Add custom consents as part of the registration info.
    func withCustomConsent(_ consentName: String, value: Bool) -> UpdateConsentRequestBuilderType
}
