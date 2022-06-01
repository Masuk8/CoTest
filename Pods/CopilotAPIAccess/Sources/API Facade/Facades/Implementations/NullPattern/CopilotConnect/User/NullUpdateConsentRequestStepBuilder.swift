//
//  NullUpdateConsentRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 29/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

typealias NullUpdateConsentRequestBuilderType = UpdateConsentRequestStepBuilderType & NullRequestBuilder<Void, UpdateUserConsentError>

class NullUpdateConsentRequestStepBuilder: NullUpdateConsentRequestBuilderType {

    func allowCopilotUserAnalysis(_ consent: Bool) -> UpdateConsentRequestBuilderType {
        return self
    }
    
    func withCustomConsent(_ consentName: String, value: Bool) -> UpdateConsentRequestBuilderType {
        return self
    }
    
}
