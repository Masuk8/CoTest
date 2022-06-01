//
//  NullAuthenticationProvider.swift
//  ZemingoBLELayer
//
//  Created by Revital Pisman on 29/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullAuthenticationProvider: AuthenticationProvider {
    
    var isLoggedIn: Bool = false

    var accessToken: Token? = nil
    
    var canLoginSilently: Bool = false
    
    func refreshToken(WithClosure closure: @escaping RefreshTokenClosure) {
        //closure(.failure(error: .generalError(debugMessage: "")))
    }
}
