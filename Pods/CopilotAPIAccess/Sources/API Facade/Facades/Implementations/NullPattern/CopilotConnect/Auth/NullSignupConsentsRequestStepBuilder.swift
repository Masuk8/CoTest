//
//  NullSignupConsentsRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 29/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullSignupConsentsRequestStepBuilder: SignupConsentsRequestStepBuilderType {
    
    var withNoGDPRConsentRequired: SignupRequestStepBuilderType = NullSignupRequestStepBuilder()
    
    func withCopilotAnalysisConsent(_ consent: Bool) -> SignupGDPRCompliantRequestStepBuilderType {
        return NullSignupRequestStepBuilder()
    }
}
