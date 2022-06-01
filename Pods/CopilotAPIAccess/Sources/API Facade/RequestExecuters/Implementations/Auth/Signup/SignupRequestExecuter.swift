//
//  SignupRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public class SignupRequestExecuter<T: Error>: RequestExecuter<Void, T> {
    
    internal let consents: [String: Bool]
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    internal let dependencies: Dependencies
    
    init(consents: [String: Bool], dependencies: Dependencies) {
        self.consents = consents
        self.dependencies = dependencies
        super.init()
    }
    
    public override func execute(_ closure: @escaping (Response<Void, T>) -> Void) {
        fatalError("This method should be overwritten")
    }
}
