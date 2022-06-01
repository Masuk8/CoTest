//
//  ApproveTermsOfUseRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class ApproveTermsOfUseRequestBuilder: RequestBuilder<Void, ApproveTermsOfUseError> {
        
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    private let dependencies: Dependencies
    
    private let version: String
    
    init(version: String, dependencies: Dependencies) {
        self.version = version
        self.dependencies = dependencies
    }
    
    override func build() -> RequestExecuter<Void, ApproveTermsOfUseError> {
        return ApproveTermsOfUseRequestExecuter(version: version, dependencies: dependencies)
    }
}
