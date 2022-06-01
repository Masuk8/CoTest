//
//  FetchConfigRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class FetchConfigRequestExecuter: RequestExecuter<Configuration, FetchConfigurationError> {
    
    typealias Dependencies = HasSystemConfigurationServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<Configuration, FetchConfigurationError>) -> Void) {
        dependencies.configurationServiceInteraction.getConfiguration(getConfigurationClosure: closure)
    }
}
