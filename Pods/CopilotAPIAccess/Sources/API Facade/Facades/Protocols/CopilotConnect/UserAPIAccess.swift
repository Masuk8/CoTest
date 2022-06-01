//
//  UserFacade.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public typealias UpdateRequestStepBuilderType = UpdateMeRequestStepBuilderType & UpdateConsentRequestStepBuilderType & ApproveTermsOfUseRequestStepBuilderType & ChangePasswordRequestStepBuilderType

public protocol UserAPIAccess: AnyObject {
    
    /// First step to elevate a user (example: elevate an anonymous user)
    func elevate() -> ElevateUserRequestStepBuilderType
    
    /// Attempt to send a verification email to the current loggedin user email address
    func sendVerificationEmail() -> RequestBuilder<Void, SendVerificationEmailError>
    
    /// Reset password passing the email address of the user who wants to reset his password
    func resetPassword(for email: String) -> RequestBuilder<Void, ResetPasswordError>
    
    /// Fetch user details for the current session
    func fetchMe() -> RequestBuilder<UserMe, FetchMeError>
    
    /// First step to update user details
    func updateMe() -> UpdateRequestStepBuilderType

    // Delete current user
    func deleteMe() -> RequestBuilder<Void, DeleteUserError>
}



