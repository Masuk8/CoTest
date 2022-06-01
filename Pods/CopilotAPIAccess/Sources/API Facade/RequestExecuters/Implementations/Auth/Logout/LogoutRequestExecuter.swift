//
//  LogoutRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class LogoutRequestExecuter: RequestExecuter<Void, LogoutError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<(), LogoutError>) -> Void) {
        dependencies.authenticationServiceInteraction.logout(logoutClosure: closure)
    }
}
