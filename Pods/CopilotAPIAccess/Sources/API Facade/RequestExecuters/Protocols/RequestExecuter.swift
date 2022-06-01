//
//  BaseRequestBuilderExecutable.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 10/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public class RequestExecuter<R, E: Error> {
    
    public func execute(_ closure: @escaping (Response<R, E>) -> Void) {
        fatalError("Needs to be overridden by child class")
    }
}
