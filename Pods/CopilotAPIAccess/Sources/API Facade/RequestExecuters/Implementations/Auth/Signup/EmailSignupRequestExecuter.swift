//
//  EmailSignupRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 26/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class EmailSignupRequestExecuter: SignupRequestExecuter<SignupError> {
    
    private let email: String
    private let password: String
    private let firstname: String
    private let lastname: String
    
    init(email: String,
         password: String,
         firstname: String,
         lastname: String,
         consents: [String: Bool],
         dependencies: Dependencies) {
        
        self.email = email
        self.password = password
        self.firstname = firstname
        self.lastname = lastname
        super.init(consents: consents, dependencies: dependencies)
    }
    
    override func execute(_ closure: @escaping (Response<Void, SignupError>) -> Void) {
        dependencies.authenticationServiceInteraction.register(withEmail: email, password: password, firstName: firstname, lastName: lastname, consents: consents) { (response) in
            switch response {
            case .success:
                // closure should not be weak because no one hold it strongly to send analytics report
                self.dependencies.userServiceInteraction.me(getCurrentUserClosure: { (_) in
                    self.dependencies.reporter.log(event: SignupAnalyticsEvent())
                    closure(response)
                })
            default:
                closure(response)
            }
        }
    }
}
