//
//  FetchThingsRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import UIKit

class FetchThingsRequestBuilder: RequestBuilder<[Thing], FetchThingsError> {
    
    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<[Thing], FetchThingsError> {
        return FetchThingsRequestExecuter(dependencies: dependencies)
    }
}
