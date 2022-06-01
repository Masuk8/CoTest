//
//  FetchMeRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class FetchMeRequestBuilder: RequestBuilder<UserMe, FetchMeError> {
    
    typealias Dependencies = HasUserServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<UserMe, FetchMeError> {
        return FetchMeRequestExecuter(dependencies: dependencies)
    }
}
