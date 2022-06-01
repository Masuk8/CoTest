//
//  UpdateConsentRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class UpdateConsentRequestExecuter: RequestExecuter<Void, UpdateUserConsentError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction
    private let dependencies: Dependencies
    
    private let consents: [String: Bool]
    
    init(consents: [String: Bool], dependencies: Dependencies) {
        self.consents = consents
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<Void, UpdateUserConsentError>) -> Void) {
        dependencies.authenticationServiceInteraction.setConsents(details: consents) { (response) in
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
