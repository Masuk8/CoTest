//
//  NullYourOwn.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 26/06/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public class NullYourOwn: YourOwnAccess {
    
    public var auth: ExternalAuthAccess
    
    init() {
        auth = NullExternalAuth()
    }
    
    public func sessionStarted(withUserId userId: String, isCopilotAnalysisConsentApproved: Bool) {
        logYourOwnError()
    }
    
    public func sessionEnded() {
        logYourOwnError()
    }
    
    public func setCopilotAnalysisConsent(isConsentApproved: Bool) {
        logYourOwnError()
    }
    
    private func logYourOwnError() {
        ZLogManagerWrapper.sharedInstance.logError(message: "Illegal operation - `YourOwn` operations are illegal to perform when using `CopilotConnect` ManageType configuration")
    }
    
}
