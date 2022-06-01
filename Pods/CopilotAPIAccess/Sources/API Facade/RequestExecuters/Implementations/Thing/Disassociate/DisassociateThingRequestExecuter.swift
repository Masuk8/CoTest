//
//  DisassociateThingRequestExecuter.swift
//  Copilot
//
//  Created by Adaya on 22/01/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class DisassociateThingRequestExecuter: RequestExecuter<Void, DisassociateThingError> {
    
    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    private let physicalID: String
    
    init(physicalID: String, dependencies: Dependencies) {
        self.physicalID = physicalID
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<Void, DisassociateThingError>) -> Void) {
        dependencies.thingsServiceInteraction.disassociateThing(physicalID: physicalID, disassociateThingClosure: closure)
    }
}
