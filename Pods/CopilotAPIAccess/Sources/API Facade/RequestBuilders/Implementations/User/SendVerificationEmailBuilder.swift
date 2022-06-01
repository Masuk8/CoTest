//
//  SendVerificationEmailBuilder.swift
//  CopilotAPIAccess
//
//  Created by Adaya on 07/03/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
//

class SendVerificationEmailBuilder: RequestBuilder<Void, SendVerificationEmailError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Void, SendVerificationEmailError> {
        return SendVerificationEmailExecuter(dependencies: dependencies)
    }
}
