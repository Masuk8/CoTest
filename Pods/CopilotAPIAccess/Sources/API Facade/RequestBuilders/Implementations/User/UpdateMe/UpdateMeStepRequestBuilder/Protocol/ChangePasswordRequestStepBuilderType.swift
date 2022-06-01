//
//  File.swift
//  CopilotAPIAccess
//
//  Created by Adaya on 07/03/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public typealias ChangePasswordRequestBuilderType = RequestBuilder<Void, ChangePasswordError>

public protocol ChangePasswordRequestStepBuilderType {
    /// Change the current user (loggedin) password with new password; assuming that the old password matches the current one
    func withNewPassword(_ newPassword: String, verifyWithOldPassword oldPassword: String) -> ChangePasswordRequestBuilderType
}

