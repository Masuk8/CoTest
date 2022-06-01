//
//  FetchConfigRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class FetchConfigRequestBuilder: RequestBuilder<Configuration, FetchConfigurationError> {

    typealias Dependencies = HasSystemConfigurationServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }

    override func build() -> RequestExecuter<Configuration, FetchConfigurationError> {
        return FetchConfigRequestExecuter(dependencies: dependencies)
    }
}
