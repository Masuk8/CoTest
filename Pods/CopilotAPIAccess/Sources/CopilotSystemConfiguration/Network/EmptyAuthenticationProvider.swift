//
//  EmptyAuthenticationProvider.swift
//  ZemingoBLELayer
//
//  Created by Revital Pisman on 27/06/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class EmptyAuthenticationProvider: AuthenticationProvider {
  
    var isLoggedIn: Bool = false
    
    fileprivate var token: Token? = nil
    
    var accessToken: Token? {
        get {
            return token
        }
    }
    
    var canLoginSilently: Bool {
        return false
    }
    
    func refreshToken(WithClosure closure: @escaping RefreshTokenClosure) {
        closure(.failure(error: .generalError(debugMessage: "")))
    }
    
}
