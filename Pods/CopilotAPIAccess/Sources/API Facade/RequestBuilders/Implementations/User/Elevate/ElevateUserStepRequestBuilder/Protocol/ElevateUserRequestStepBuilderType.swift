//
//  ElevateUserRequestStepBuilderType.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 10/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public protocol ElevateUserRequestStepBuilderType {
    /// Elevate anonymous user to a email registered user passing the required parameters, call execute() after
    func with(email: String, password: String, firstname: String, lastname: String) -> RequestBuilder<Void, ElevateAnonymousUserError>
}
