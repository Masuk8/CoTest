//
//  ExistingSessionLoginRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class ExistingSessionLoginRequestBuilder: RequestBuilder<Void, LoginSilentlyError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Void, LoginSilentlyError> {
        return ExistingSessionLoginRequestExecuter(dependencies: dependencies)
    }
}
