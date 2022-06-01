//
//  NullUserAPI.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 24/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullUserAPI: UserAPIAccess {

    func elevate() -> ElevateUserRequestStepBuilderType {
        return NullElevateUserRequestStepBuilder()
    }
    
    func sendVerificationEmail() -> RequestBuilder<Void, SendVerificationEmailError> {
        return NullRequestBuilder<Void, SendVerificationEmailError>()
    }
    
    func resetPassword(for email: String) -> RequestBuilder<Void, ResetPasswordError> {
        return NullRequestBuilder<Void, ResetPasswordError>()
    }
    
    func fetchMe() -> RequestBuilder<UserMe, FetchMeError> {
        return NullRequestBuilder<UserMe, FetchMeError>()
    }
    
    func updateMe() -> UpdateRequestStepBuilderType {
        return NullUpdateRequestStepBuilder()
    }

    func deleteMe() -> RequestBuilder<Void, DeleteUserError> {
        return NullRequestBuilder<Void, DeleteUserError>()
    }
}
