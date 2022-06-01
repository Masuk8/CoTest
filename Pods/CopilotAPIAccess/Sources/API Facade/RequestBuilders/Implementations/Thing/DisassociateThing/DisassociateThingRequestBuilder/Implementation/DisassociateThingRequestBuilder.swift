//
//  DisassociateThingRequestBuilder.swift
//  ZemingoBLELayer
//
//  Created by Adaya on 22/01/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class DisassociateThingRequestBuilder : RequestBuilder<Void, DisassociateThingError>{
    
    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    private let physicalID: String
    
    init(physicalID: String, dependencies: Dependencies) {
        self.physicalID = physicalID
        self.dependencies = dependencies
    }
    
    override func build() -> RequestExecuter<Void, DisassociateThingError> {
        return DisassociateThingRequestExecuter(physicalID: physicalID, dependencies: dependencies)
    }
}
