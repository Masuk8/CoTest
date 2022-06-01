//
//  MarkForDeletionRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class MarkForDeletionRequestBuilder: RequestBuilder<Void, ConsentRefusedError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Void, ConsentRefusedError> {
        return MarkForDeletionRequestExecuter(dependencies: dependencies)
    }
}
