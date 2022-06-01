//
//  SendVerificationEmailExecuter.swift
//  CopilotAPIAccess
//
//  Created by Adaya on 07/03/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
class SendVerificationEmailExecuter: RequestExecuter<Void, SendVerificationEmailError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<Void, SendVerificationEmailError>) -> Void) {
        dependencies.authenticationServiceInteraction.sendVerificationEmail(closure: closure)
    }
}
