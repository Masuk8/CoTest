//
//  SignupRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public class SignupRequestBuilder<T: Error>: RequestBuilder<Void, T> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    internal let dependencies: Dependencies
    internal let consents: [String: Bool]
    
    init(consents: [String: Bool],
         dependencies: Dependencies) {
        self.consents = consents
        self.dependencies = dependencies
        super.init()
    }
    
    public override func build() -> RequestExecuter<Void, T> {
        return SignupRequestExecuter(consents: consents, dependencies: dependencies)
    }
}
