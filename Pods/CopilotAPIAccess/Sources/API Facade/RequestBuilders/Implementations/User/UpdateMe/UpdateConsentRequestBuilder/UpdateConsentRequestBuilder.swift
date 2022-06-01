//
//  UpdateConsentRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class UpdateConsentRequestBuilder: RequestBuilder<Void, UpdateUserConsentError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction
    private let dependencies: Dependencies
    
    fileprivate var consents: [String: Bool]
    
    init(consents: [String: Bool], dependencies: Dependencies) {
        self.consents = consents
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Void, UpdateUserConsentError> {
        return UpdateConsentRequestExecuter(consents: consents, dependencies: dependencies)
    }
}

extension UpdateConsentRequestBuilder: UpdateConsentRequestStepBuilderType {
    func allowCopilotUserAnalysis(_ consent: Bool) -> UpdateConsentRequestBuilderType {
        consents[String.analyticsConsentKey] = consent
        return self
    }
    
    func withCustomConsent(_ consentName: String, value: Bool) -> UpdateConsentRequestBuilderType {
        consents[consentName] = value
        return self
    }
    
    
}
