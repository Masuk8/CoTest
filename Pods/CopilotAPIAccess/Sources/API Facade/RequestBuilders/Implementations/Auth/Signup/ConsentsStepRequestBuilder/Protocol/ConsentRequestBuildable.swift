//
//  SignupConsentsRequestStepBuilderType.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public protocol SignupConsentsRequestStepBuilderType {
    
    /// Pass whether or not analytics consent was given (GDPR compliance).
    func withCopilotAnalysisConsent(_ consent: Bool) -> SignupGDPRCompliantRequestStepBuilderType
    
    /// State that no GDPR consent is needed.
    var withNoGDPRConsentRequired: SignupRequestStepBuilderType { get }
}
