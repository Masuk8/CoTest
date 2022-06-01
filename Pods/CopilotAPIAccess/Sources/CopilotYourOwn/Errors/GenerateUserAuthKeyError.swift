//
//  GenerateUserAuthKeyError.swift
//  ZemingoBLELayer
//
//  Created by Revital Pisman on 26/06/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public enum GenerateUserAuthKeyError: Swift.Error {
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

extension GenerateUserAuthKeyError: CopilotLocalizedError {
    public func errorPrefix() -> String {
        return "Generate User Auth Key"
    }
    
    public var errorDescription: String? {
        switch self {
        case .connectivityError(let debugMessage):
            return connectivityErrorMessage(debugMessage: debugMessage)
        case .generalError(let debugMessage):
            return generalErrorMessage(debugMessage: debugMessage)
        }
    }
}
