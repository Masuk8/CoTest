//
//  Configuration.swift
//  SystemConfigurationComponent
//
//  Created by Yulia Felberg on 22/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public struct Configuration {
    
    private enum Constants {
        static let privacyPolicyKey = "privacyPolicy"
        static let termsAndConditionsKey = "termsAndConditions"
        static let faqKey = "faq"
    }
    
    public var privacyPolicy: DynamicUrl?
    public var termsAndConditions: DynamicUrl?
    public var faq: DynamicUrl?
    
    //MARK: Init
    
    private init() {
        privacyPolicy = nil
        termsAndConditions = nil
        faq = nil
    }

    init?(withDictionary dictionary: [String: Any]) {
        //BUG: one of the documents should be allowed to not exist... currently both are mandatory 
        guard let privacyPolicyDict = dictionary[Constants.privacyPolicyKey] as? [String: Any] else {
            ZLogManagerWrapper.sharedInstance.logError(message: "unable to parse dictionary to privacyPolicyDoc with dict: \(dictionary)")
            return nil
        }
        
        guard let termsOfUseDict = dictionary[Constants.termsAndConditionsKey] as? [String: Any] else {
            ZLogManagerWrapper.sharedInstance.logError(message: "unable to parse dictionary to termsOfUseDoc with dict: \(dictionary)")
            return nil
        }
        
        guard let termsOfUseLegalDocument = DynamicUrl(withDictionary: termsOfUseDict) else {
            ZLogManagerWrapper.sharedInstance.logError(message: "unable to create termsOfUseLegalDocument from dictionary: \(dictionary)")
            return nil
        }
        
        guard let privacyPolicyLegalDocument = DynamicUrl(withDictionary: privacyPolicyDict) else {
            ZLogManagerWrapper.sharedInstance.logError(message: "unable to create privacyPolicyLegalDocument from dictionary: \(dictionary)")
            return nil
        }
        
        privacyPolicy = privacyPolicyLegalDocument
        termsAndConditions = termsOfUseLegalDocument
        
        if let faqDic = dictionary[Constants.faqKey] as? [String: Any] {
            if let faqLegalDocument = DynamicUrl(withDictionary: faqDic)  {
                faq = faqLegalDocument
            }
            else{
                ZLogManagerWrapper.sharedInstance.logInfo(message: "unable to create faq from dictionary: \(dictionary)")
            }
        }
        else{
            ZLogManagerWrapper.sharedInstance.logInfo(message: "unable to extract as dictionary \(Constants.faqKey) from dictionary: \(dictionary)")
        }
    }
}
