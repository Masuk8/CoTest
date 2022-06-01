//
//  LogoutRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class LogoutRequestBuilder: RequestBuilder<Void, LogoutError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction
    fileprivate let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Void, LogoutError> {
        return LogoutRequestExecuter(dependencies: dependencies)
    }
}

extension LogoutRequestBuilder: MarkForDeletionRequestStepBuilderType {
    var markForDeletion: RequestBuilder<Void, ConsentRefusedError> {
        return MarkForDeletionRequestBuilder(dependencies: dependencies)
    }

}
