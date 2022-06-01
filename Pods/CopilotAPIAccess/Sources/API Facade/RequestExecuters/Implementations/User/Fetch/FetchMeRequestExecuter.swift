//
//  FetchMeRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class FetchMeRequestExecuter: RequestExecuter<UserMe, FetchMeError> {
    
    typealias Dependencies = HasUserServiceInteraction
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<UserMe, FetchMeError>) -> Void) {
        dependencies.userServiceInteraction.me(getCurrentUserClosure: closure)
    }
}
