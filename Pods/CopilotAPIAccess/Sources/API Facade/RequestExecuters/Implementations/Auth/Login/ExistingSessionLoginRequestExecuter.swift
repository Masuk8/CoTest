//
//  ExistingSessionLoginRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class ExistingSessionLoginRequestExecuter: RequestExecuter<Void, LoginSilentlyError> {        
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<Void, LoginSilentlyError>) -> Void) {
        dependencies.authenticationServiceInteraction.attemptToSilentLogin { (response) in
            switch response {
            case .success:
                self.dependencies.userServiceInteraction.me(getCurrentUserClosure: { (_) in
                    closure(response)
                })
            default:
                closure(response)
            }
        }
    }
}
