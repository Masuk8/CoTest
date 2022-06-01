//
//  SignupConsentsRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class SignupConsentsRequestStepBuilder {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    fileprivate let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension SignupConsentsRequestStepBuilder: SignupConsentsRequestStepBuilderType {
    
    func withCopilotAnalysisConsent(_ consent: Bool) -> SignupGDPRCompliantRequestStepBuilderType {
        return SignupRequestStepBuilder(consents: [String.analyticsConsentKey : consent], dependencies: dependencies)
    }
    
    var withNoGDPRConsentRequired: SignupRequestStepBuilderType {
        return SignupRequestStepBuilder(consents: [:], dependencies: dependencies)
    }
}
