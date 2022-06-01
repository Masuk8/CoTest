//
//  NullExternalAuth.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 26/06/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public class NullExternalAuth: ExternalAuthAccess {
    
    public func setCopilotTokenProvider(_ tokenProvider: CopilotTokenProvider) {
        ZLogManagerWrapper.sharedInstance.logError(message: "Illegal operation - `YourOwn` operations are illegal to perform when using `CopilotConnect` ManageType configuration")
    }
    
}
