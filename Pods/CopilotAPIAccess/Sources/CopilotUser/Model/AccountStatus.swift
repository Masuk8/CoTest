//
//  AccountStatus.swift
//  User
//
//  Created by Adaya on 17/12/2017.
//  Copyright © 2017 Falcore. All rights reserved.
//

import Foundation
import CopilotLogger

public class AccountStatus : CustomStringConvertible {
    
    enum Constants {
        static let termsOfUseApproved = "termsOfUseApproved"
        static let consents = "consents"
        static let consentKey = "key"
        static let consentValueKey = "value"
        static let credentialsTypeKey = "credentialsType"
        static let emailVerificationStatus = "emailVerificationStatus"
    }
    
    public let termsOfUseApproved : Bool
    public let credentialsType: CredentialsType
    public let emailVerificationStatus: EmailVerificationStatus
    private var consents: [String:ConsentStatus]?
    public var consentsKeys: [String]? {
        return consents?.keys.map({ return $0 })
    }
    
    init?(withDictionary dictionary: [String: Any]) {
        guard let termsOfUse = dictionary[Constants.termsOfUseApproved] as? Bool,
              let credentialsTypeRawValue = dictionary[Constants.credentialsTypeKey] as? String else {
            ZLogManagerWrapper.sharedInstance.logError(message: "Account status did not contain an entry for termsOfUseApproved")
            return nil
        }
        let emailVerificationStatusRawValue = dictionary[Constants.emailVerificationStatus] as? String
        
        termsOfUseApproved = termsOfUse
        credentialsType = CredentialsType(rawValue: credentialsTypeRawValue) ?? .unknown
        if let emailVerificationStatusRawValue = emailVerificationStatusRawValue{
            emailVerificationStatus = EmailVerificationStatus(rawValue: emailVerificationStatusRawValue) ?? .unknown
        }
        else{
            ZLogManagerWrapper.sharedInstance.logWarning(message: "Couldnt find the email verification status in the user model")
            emailVerificationStatus = .unknown
        }
        if let consentsFromDictionary = consentsFromDictionary(dictionary: dictionary) {
           consents = consentsFromDictionary
        }
        else {
            ZLogManagerWrapper.sharedInstance.logInfo(message:"No consents")
        }
    }
    
    // MARK: - Private
    private func consentsFromDictionary(dictionary: [String: Any]) -> [String:ConsentStatus]? {
        
        let consents: [String:ConsentStatus]?
        
        if let consentsResponse = dictionary[Constants.consents] as? [[String: String]]{
            ZLogManagerWrapper.sharedInstance.logInfo(message: "Consents are: \(consentsResponse)")
            
            var prasedConsents = [String:ConsentStatus]()
            
            consentsResponse.forEach({ (consentDictionary) in
                let consentKey = consentDictionary[Constants.consentKey]
                let consentValue = consentDictionary[Constants.consentValueKey]
                
                if let consentRealKey = consentKey, let consentRealValue = consentValue, let consentStatus = ConsentStatus(rawValue: consentRealValue) {
                    prasedConsents[consentRealKey] = consentStatus
                }
                else {
                    ZLogManagerWrapper.sharedInstance.logError(message:"Could not create a consent from consent dictionary: \(consentDictionary)")
                }
            })
            
            if prasedConsents.count > 0 {
                consents = prasedConsents
            }
            else {
                consents = nil
            }
        }
        else{
            consents = nil
        }
        
        return consents
    }
    
    // MARK: - Public
    public var description: String{
        return "Terms of use approved? \(termsOfUseApproved), emailVerificationStatus: \(emailVerificationStatus), credentialsType: \(credentialsType),consents: \(consents?.description ?? "empty")"
    }
    
    public var copilotUserAnalysisConsent: ConsentStatus {
        guard let consent = consents?[String.analyticsConsentKey] else {
            return .unset
        }
        return consent
    }
    
    public func consent(for key: String) -> ConsentStatus {
        guard let consent = consents?[key] else { return .unset }
        return consent
    }
}
