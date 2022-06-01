//
//  AnonymousSignupRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class AnonymousSignupRequestExecuter: SignupRequestExecuter<SignupAnonymouslyError> {
    
    override func execute(_ closure: @escaping (Response<Void, SignupAnonymouslyError>) -> Void) {
        dependencies.authenticationServiceInteraction.registerAnonymously(withConsents: consents) { (response) in
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
