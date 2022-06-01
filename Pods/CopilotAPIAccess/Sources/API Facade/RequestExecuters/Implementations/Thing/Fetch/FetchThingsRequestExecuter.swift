//
//  FetchThingsRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class FetchThingsRequestExecuter: RequestExecuter<[Thing], FetchThingsError> {
    
    typealias Dependencies = HasThingsServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<[Thing], FetchThingsError>) -> Void) {
        dependencies.thingsServiceInteraction.getAssociatedThings(getThingsClosure: closure)
    }
}
