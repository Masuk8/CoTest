//
//  MarkForDeletionRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class MarkForDeletionRequestExecuter: RequestExecuter<Void, ConsentRefusedError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<(), ConsentRefusedError>) -> Void) {
        dependencies.authenticationServiceInteraction.consentRefused { [weak self] (consentRefusedResult) in
            self?.dependencies.authenticationServiceInteraction.logout(logoutClosure: {_ in })
            closure(consentRefusedResult)
        }
    }
}
