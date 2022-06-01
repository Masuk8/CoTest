//
//  ExternalAuthAPIAccess.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 19/06/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public protocol ExternalAuthAccess: class {
    
    /// Set external token provider
    func setCopilotTokenProvider(_ tokenProvider: CopilotTokenProvider)
}
