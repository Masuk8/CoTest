//
//  UpdateMeRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

class UpdateMeRequestStepBuilder: RequestBuilder<UserMe, UpdateUserDetailsError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    fileprivate let dependencies: Dependencies
    
    fileprivate var firstname: String?
    fileprivate var lastname: String?
    fileprivate var customSettings: [String: Any] = [:]
    private var error: UpdateUserDetailsError? = nil
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<UserMe, UpdateUserDetailsError> {
        return UpdateMeRequestExecuter(firstname: firstname,
                                       lastname: lastname,
                                       customSettings: customSettings,
                                       error: error,
                                       dependencies: dependencies)
    }
    
}

extension UpdateMeRequestStepBuilder: UpdateMeRequestStepBuilderType {
    
    func with(firstname: String) -> UpdateMeDetailsRequestBuilderType {
        self.firstname = firstname
        return self
    }
    
    func with(lastname: String) -> UpdateMeDetailsRequestBuilderType {
        self.lastname = lastname
        return self
    }
    
    func with<T: Encodable>(customValue value: T, forKey key: String) -> UpdateMeDetailsRequestBuilderType {
        do {
            let data = try JSONEncoder().encode([key : value])
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                customSettings[key] = json[key]
            }
        } catch {
            let updateUserDetailsError = UpdateUserDetailsError.invalidParameters(debugMessage: "failed to add custom settings value - \(value) key - \(key) with error: \(error)")
            self.error = updateUserDetailsError
            ZLogManagerWrapper.sharedInstance.logError(message: "failed to add custom settings value - \(value) key - \(key) with error: \(error)")
        }
        
        return self
    }
    
    func removeCustomValue(forKey key: String) -> UpdateMeDetailsRequestBuilderType {
        customSettings.unsetValue(forKey: key)
        return self
    }
}

extension UpdateMeRequestStepBuilder: UpdateConsentRequestStepBuilderType {
    
    func allowCopilotUserAnalysis(_ consent: Bool) -> UpdateConsentRequestBuilderType {
        return UpdateConsentRequestBuilder(consents: [String.analyticsConsentKey : consent], dependencies: dependencies)
    }
    
    func withCustomConsent(_ consentName: String, value: Bool) -> UpdateConsentRequestBuilderType {
        return UpdateConsentRequestBuilder(consents: [consentName : value], dependencies: dependencies)
    }
}

extension UpdateMeRequestStepBuilder: ApproveTermsOfUseRequestStepBuilderType {
    
    func approveTermsOfUse(forVersion version: String) -> RequestBuilder<Void, ApproveTermsOfUseError> {
        return ApproveTermsOfUseRequestBuilder(version: version, dependencies: dependencies)
    }
}

extension UpdateMeRequestStepBuilder: UpdateUserDeviceDetailsRequestStepBuilderType {
    
    func withPushToken(pnsToken: Data, isSandbox: Bool) -> RequestBuilder<Void, UpdateDeviceDetailsError> {
        return UpdateDeviceDetailsRequestBuilder(pnsToken: pnsToken, isSandbox: isSandbox, dependencies: dependencies)
    }
}

extension UpdateMeRequestStepBuilder : ChangePasswordRequestStepBuilderType{
    func withNewPassword(_ newPassword: String, verifyWithOldPassword oldPassword: String) -> ChangePasswordRequestBuilderType {
        return ChangePasswordRequestBuilder(newPassword: newPassword, oldPassword: oldPassword, dependencies: dependencies)
    }
}
