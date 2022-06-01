//
//  NullCopilotConnect.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 23/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public class NullCopilotConnect: CopilotConnectAccess {
    
    public let app: AppAPIAccess = NullAppAPI()
    public let auth: AuthAPIAccess = NullAuthAPI()
    public let user: UserAPIAccess = NullUserAPI()
    public let thing: ThingAPIAccess = NullThingAPI()
    
    public var defaultAuthProvider: AuthenticationProvider {
        return NullAuthenticationProvider()
    }
}
