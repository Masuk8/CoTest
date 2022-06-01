//
//  NullRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 24/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullRequestBuilder<Value, E: CopilotError>: RequestBuilder<Value, E> {
    override func build() -> RequestExecuter<Value, E> {
        return NullRequestExecuter<Value, E>()
    }
}
