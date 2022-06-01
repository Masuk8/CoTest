//
//  UpdateUserError.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 11/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public enum UpdateUserDetailsError: CopilotError {
    static func generalError(message: String) -> UpdateUserDetailsError {
        return .generalError(debugMessage: message)
    }
    
    case invalidParameters(debugMessage: String)
    case requiresRelogin(debugMessage: String)
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

public class UpdateUserDetailsErrorResolver : ErrorResolver{
    public typealias T = UpdateUserDetailsError
    
    public func fromRequiresReloginError(debugMessage: String) -> UpdateUserDetailsError {
        return .requiresRelogin(debugMessage: debugMessage)
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> UpdateUserDetailsError {
        return .invalidParameters(debugMessage: debugMessage)
    }
    
    public func fromGeneralError(debugMessage: String) -> UpdateUserDetailsError {
        return .generalError(debugMessage: debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> UpdateUserDetailsError {
        return .connectivityError(debugMessage:debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> UpdateUserDetailsError? {
        return nil
    }
}





extension UpdateUserDetailsError: CopilotLocalizedError {
    public func errorPrefix() -> String {
        return "Update User Details"
    }
    
    public var errorDescription: String? {
        switch self {
        case .invalidParameters(let debugMessage):
            return invalidParametersMessage(debugMessage: debugMessage)
        case .requiresRelogin(let debugMessage):
            return requiresReloginMessage(debugMessage: debugMessage)
        case .generalError(let debugMessage):
            return generalErrorMessage(debugMessage: debugMessage)
        case .connectivityError(let debugMessage):
            return connectivityErrorMessage(debugMessage: debugMessage)
        }
    }
}
