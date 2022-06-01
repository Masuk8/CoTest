//
//  User.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class UserAPI: UserAPIAccess {

    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func elevate() -> ElevateUserRequestStepBuilderType {
        return ElevateUserRequestStepBuilder(dependencies: dependencies)
    }

    func resetPassword(for email: String) -> RequestBuilder<Void, ResetPasswordError> {
        return ResetPasswordRequestBuilder(email: email, dependencies: dependencies)
    }
    
    func fetchMe() -> RequestBuilder<UserMe, FetchMeError> {
        return FetchMeRequestBuilder(dependencies: dependencies)
    }
    
    func sendVerificationEmail() -> RequestBuilder<Void, SendVerificationEmailError>{
        return SendVerificationEmailBuilder(dependencies: dependencies)
    }
    
    func updateMe() -> UpdateRequestStepBuilderType {
        return UpdateMeRequestStepBuilder(dependencies: dependencies)
    }

    func deleteMe() -> RequestBuilder<Void, DeleteUserError> {
        return DeleteUserRequestBuilder(dependencies: dependencies)
    }
}
