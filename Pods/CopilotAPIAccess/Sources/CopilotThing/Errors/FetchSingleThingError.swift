//
//  FetchThingError.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 11/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public enum FetchSingleThingError: CopilotError {
    static func generalError(message: String) -> FetchSingleThingError {
        return .generalError(debugMessage: message)
    }
    case thingNotFound(debugMessage: String)
    case thingIsNotAssociated(debugMessage: String)
    case invalidParameters(debugMessage: String)
    case requiresRelogin(debugMessage: String)
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

public class FetchSingleThingErrorResolver : ErrorResolver{
    public typealias T = FetchSingleThingError
    
    public func fromRequiresReloginError(debugMessage: String) -> FetchSingleThingError {
        return .requiresRelogin(debugMessage: debugMessage)
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> FetchSingleThingError {
        return .invalidParameters(debugMessage: debugMessage)
    }
    
    public func fromGeneralError(debugMessage: String) -> FetchSingleThingError {
        return .generalError(debugMessage: debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> FetchSingleThingError {
        return .connectivityError(debugMessage:debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> FetchSingleThingError? {
        if isEntityNotFound(statusCode, reason){
            return .thingNotFound(debugMessage: message)
        }
        if isOperationForbidden(statusCode, reason){
            return .thingIsNotAssociated(debugMessage: message)
        }
        return nil
    }
}





extension FetchSingleThingError: CopilotLocalizedError {
    public func errorPrefix() -> String {
        return "Fetch Single Thing"
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
