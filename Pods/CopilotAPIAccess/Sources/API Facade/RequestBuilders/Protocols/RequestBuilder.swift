//
//  RequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public class RequestBuilder<R, E: Error> {
    
    public func build() -> RequestExecuter<R, E> {
        fatalError("Needs to be overridden by child class")
    }
}
