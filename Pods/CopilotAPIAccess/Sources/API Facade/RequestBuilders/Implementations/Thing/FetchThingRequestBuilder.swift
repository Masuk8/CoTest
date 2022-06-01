//
//  FetchThingRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class FetchThingRequestBuilder: RequestBuilder<Thing, FetchSingleThingError> {
    
    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    private let physicalId: String
    
    init(physicalId: String, dependencies: Dependencies) {
        self.physicalId = physicalId
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Thing, FetchSingleThingError> {
        return FetchThingRequestExecuter(physicalId: physicalId, dependencies: dependencies)
    }
}
