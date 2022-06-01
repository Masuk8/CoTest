//
//  EmailPasswordLoginRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class EmailPasswordLoginRequestExecuter: RequestExecuter<Void, LoginError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    private let dependencies: Dependencies
    
    private let email: String
    private let password: String
    
    init(email: String, password: String, dependencies: Dependencies) {
        self.email = email
        self.password = password
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<Void, LoginError>) -> Void) {
        
        dependencies.authenticationServiceInteraction.login(withEmail: email, password: password, loginClosure: { (response) in
            switch response {
            case .success:
                // closure should not be weak because no one hold it strongly to send analytics report
                self.dependencies.userServiceInteraction.me(getCurrentUserClosure: { (_) in
                    self.dependencies.reporter.log(event: LoginAnalyticsEvent())
                    closure(response)
                })
            default:
                closure(response)
            }
        })
    }
}
