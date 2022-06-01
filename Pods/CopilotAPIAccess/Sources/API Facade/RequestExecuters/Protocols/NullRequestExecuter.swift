//
//  NullRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 24/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullRequestExecuter<Value, E: CopilotError>: RequestExecuter<Value, E> {
    override func execute(_ closure: @escaping (Response<Value, E>) -> Void) {
        closure(.failure(error: E.generalError(message: "Illegal operation - `CopilotConnect` operations are illegal to perform when using `YourOwn` ManageType configuration")))
    }
}
