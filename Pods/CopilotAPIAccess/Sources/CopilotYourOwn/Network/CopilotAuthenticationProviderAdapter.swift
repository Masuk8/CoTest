//
//  CopilotAuthenticationProviderAdapter.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 25/06/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

class CopilotAuthenticationProviderAdapter: AuthenticationProvider {
  
    var isLoggedIn: Bool {
        get {
            return canLoginSilently
        }
    }
    
    
    fileprivate var token: Token?
    
    private var copilotTokenProvider: CopilotTokenProvider?
    
    private var userId: String?
    
    //MARK: Init
    
    init() {
        self.copilotTokenProvider = nil
    }
    
    //MARK: AuthenticationProvider
    
    var accessToken: Token? {
        get {
            return token
        }
    }
    
    var canLoginSilently: Bool {
        return userId != nil
    }
    
    func refreshToken(WithClosure closure: @escaping RefreshTokenClosure) {
        generateAccessToken { (response) in
            switch response {
            case .success(_):
                closure(.success(()))
            case .failure(let error):
                closure(.failure(error: RefreshTokenError(generateUserAuthKeyError: error)))
            }
        }
    }
    
    func setUserId(_ userId: String?) {
        self.userId = userId
    }
    
    func setExternalAuthenticationProvider(_ tokenProvider: CopilotTokenProvider) {
        copilotTokenProvider = tokenProvider
    }
    
    func resetExternalTokenProvider() {
        token = nil
        userId = nil
    }
    
    //MARK: Private functions
    
    private func generateAccessToken(WithClosure closure: GenerateUserAuthKeyClosure? = nil) {
        guard let userId = self.userId else {
            ZLogManagerWrapper.sharedInstance.logError(message: "failed to get user Id")
            closure?(.failure(error: .generalError(debugMessage: "failed to get user Id")))
            return
        }
        
        copilotTokenProvider?.generateUserAuthKey(for: userId) { [weak self] (response) in
            switch response {
            case .success(let authKey):
                if let decodedAuthKeyData = Data(base64Encoded: authKey) {
                    
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: decodedAuthKeyData, options: []) as? [String: Any],
                            let accessToken = dict["access_token"] as? String {
                            self?.token = accessToken
                            closure?(.success(accessToken))
                        }
                        else {
                            closure?(.failure(error: .generalError(debugMessage: "access_token key not exist")))
                        }
                    }
                    catch {
                        ZLogManagerWrapper.sharedInstance.logError(message: "failed to parse decodedAuthKey with decodedAuthKeyData : \(decodedAuthKeyData)")
                        closure?(.failure(error: .generalError(debugMessage: "failed to parse decodedAuthKey with decodedAuthKeyData : \(decodedAuthKeyData)")))
                    }
                } else {
                    closure?(.failure(error: .generalError(debugMessage: "failed to decode auth key data with auth key : \(authKey)")))
                }
                
            case .failure(let error):
                ZLogManagerWrapper.sharedInstance.logError(message: "Failed to get access token")
                closure?(.failure(error: error))
            }
        }
    }
    
}

extension RefreshTokenError {
    
    init(generateUserAuthKeyError: GenerateUserAuthKeyError) {
        switch generateUserAuthKeyError {
        case .generalError(let debugMessage):
            self = .generalError(debugMessage: debugMessage)
        case .connectivityError(let debugMessage):
            self = .connectivityError(debugMessage: debugMessage)
        }
    }
}
