//
//  YourOwnAccess.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 20/05/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public protocol YourOwnAccess: class {
    
    var auth: ExternalAuthAccess { get }
    
    /// First step to start external session to process user data
    func sessionStarted(withUserId userId: String, isCopilotAnalysisConsentApproved: Bool)
    
    /// End external session to remove user data process
    func sessionEnded()
    
    /// Pass whether or not Copilot should process user data (GDPR compliance).
    func setCopilotAnalysisConsent(isConsentApproved: Bool)
}
