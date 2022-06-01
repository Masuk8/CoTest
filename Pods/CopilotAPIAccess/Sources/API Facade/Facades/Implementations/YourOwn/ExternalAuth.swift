//
//  ExternalAuth.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 19/06/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public class ExternalAuth: ExternalAuthAccess, ExternalAuthInternal {
    
    private let copilotAuthenticationProviderAdapter: CopilotAuthenticationProviderAdapter
    
    init(authenticationProviderContainer: AuthenticationProviderContainer) {
        
        copilotAuthenticationProviderAdapter = CopilotAuthenticationProviderAdapter()
        authenticationProviderContainer.authenticationProvider = copilotAuthenticationProviderAdapter
    }
    
    public func setCopilotTokenProvider(_ copilotTokenProvider: CopilotTokenProvider) {
        copilotAuthenticationProviderAdapter.setExternalAuthenticationProvider(copilotTokenProvider)
    }
    
    internal func resetTokenProvider() {
        copilotAuthenticationProviderAdapter.resetExternalTokenProvider()
    }
    
    func setUserId(_ userId: String?) {
        copilotAuthenticationProviderAdapter.setUserId(userId)
    }
    
}
