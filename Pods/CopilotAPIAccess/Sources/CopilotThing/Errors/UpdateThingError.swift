//
//  UpdateThingError.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 11/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public enum UpdateThingError: CopilotError {
    static func generalError(message: String) -> UpdateThingError {
        return .generalError(debugMessage: message)
    }
    
    case thingNotFound(debugMessage: String)
    case thingIsNotAssociated(debugMessage: String)
    case invalidParameters(debugMessage: String)
    case requiresRelogin(debugMessage: String)
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

public class UpdateThingErrorResolver : ErrorResolver{
    public typealias T = UpdateThingError

    public func fromRequiresReloginError(debugMessage: String) -> UpdateThingError {
        return .requiresRelogin(debugMessage: debugMessage)
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> UpdateThingError {
        return .invalidParameters(debugMessage: debugMessage)
    }
    
    public func fromGeneralError(debugMessage: String) -> UpdateThingError {
        return .generalError(debugMessage: debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> UpdateThingError {
        return .connectivityError(debugMessage:debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> UpdateThingError? {
        if isEntityNotFound(statusCode, reason){
            return .thingNotFound(debugMessage: message)
        }
        if isOperationForbidden(statusCode, reason){
            return .thingIsNotAssociated(debugMessage: message)
        }
        return nil
    }
}





extension UpdateThingError: CopilotLocalizedError {
    public func errorPrefix() -> String {
        return "Update Thing"
    }
    
    public var errorDescription: String? {
        switch self {
        case .thingNotFound(let debugMessage):
           return toString("thing not found (\(debugMessage)")
        case .thingIsNotAssociated(let debugMessage):
           return toString("thing is not associated (\(debugMessage)")
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
