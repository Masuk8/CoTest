//
//  CopilotConnectAccess.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 23/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public protocol CopilotConnectAccess: class {
    var app: AppAPIAccess { get }
    var auth: AuthAPIAccess { get }
    var user: UserAPIAccess { get }
    var thing: ThingAPIAccess { get }
    var defaultAuthProvider: AuthenticationProvider { get }
}
