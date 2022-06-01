//
//  NullUpdateRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 28/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullUpdateRequestStepBuilder: UpdateRequestStepBuilderType {
    
    func with(firstname: String) -> UpdateMeDetailsRequestBuilderType {
        return NullUpdateMeDetailsRequestBuilder()
    }
    
    func with(lastname: String) -> UpdateMeDetailsRequestBuilderType {
        return NullUpdateMeDetailsRequestBuilder()
    }
    
    func with<T>(customValue value: T, forKey key: String) -> UpdateMeDetailsRequestBuilderType where T : Encodable {
        return NullUpdateMeDetailsRequestBuilder()
    }
    
    func removeCustomValue(forKey key: String) -> UpdateMeDetailsRequestBuilderType {
        return NullUpdateMeDetailsRequestBuilder()
    }
    
    func allowCopilotUserAnalysis(_ consent: Bool) -> UpdateConsentRequestBuilderType {
        return NullUpdateConsentRequestStepBuilder()
    }
    
    func withCustomConsent(_ consentName: String, value: Bool) -> UpdateConsentRequestBuilderType {
        return NullUpdateConsentRequestStepBuilder()
    }
    
    func approveTermsOfUse(forVersion version: String) -> RequestBuilder<Void, ApproveTermsOfUseError> {
        return NullRequestBuilder<Void, ApproveTermsOfUseError>()
    }
    
    func withNewPassword(_ newPassword: String, verifyWithOldPassword oldPassword: String) -> ChangePasswordRequestBuilderType {
        return NullRequestBuilder<Void, ChangePasswordError>()
    }
}
