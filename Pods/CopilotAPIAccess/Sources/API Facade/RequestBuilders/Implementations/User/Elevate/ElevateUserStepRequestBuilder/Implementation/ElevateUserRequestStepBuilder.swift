//
//  ElevateUserRequestStepBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 10/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class ElevateUserRequestStepBuilder {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    fileprivate let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension ElevateUserRequestStepBuilder: ElevateUserRequestStepBuilderType {
    
    func with(email: String, password: String, firstname: String, lastname: String) -> RequestBuilder<Void, ElevateAnonymousUserError> {
        return ElevateUserRequestBuilder(email: email, password: password, firstname: firstname, lastname: lastname, dependencies: dependencies)
    }
}
