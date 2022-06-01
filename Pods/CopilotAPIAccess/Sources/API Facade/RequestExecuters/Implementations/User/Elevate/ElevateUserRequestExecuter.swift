//
//  ElevateUserRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class ElevateUserRequestExecuter: RequestExecuter<Void, ElevateAnonymousUserError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    private let dependencies: Dependencies
    
    private let email: String
    private let password: String
    private let firstname: String
    private let lastname: String
    
    init(email: String, password: String, firstname: String, lastname: String, dependencies: Dependencies) {
        self.email = email
        self.password = password
        self.firstname = firstname
        self.lastname = lastname
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<(), ElevateAnonymousUserError>) -> Void) {
        dependencies.authenticationServiceInteraction.elevateAnonymous(withEmail: email, password: password, firstName: firstname, lastName: lastname) { (response) in
            switch response {
            case .success:
                // closure should not be weak because no one hold it strongly to send analytics report
                self.dependencies.userServiceInteraction.me(getCurrentUserClosure: { (_) in
                    self.dependencies.reporter.log(event: SuccessfulElevateAnonymousAnalyticEvent())
                    closure(response)
                })
            default:
                closure(response)
            }
        }
    }
}
