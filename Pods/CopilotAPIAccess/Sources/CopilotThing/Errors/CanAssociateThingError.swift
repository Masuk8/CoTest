//
//  CanAssociateThingError.swift
//  CopilotAPIAccess
//
//  Created by Adaya on 22/01/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public enum CanAssociateThingError: CopilotError {
    static func generalError(message: String) -> CanAssociateThingError {
        return .generalError(debugMessage: message)
    }
    
    case invalidParameters(debugMessage: String)
    case requiresRelogin(debugMessage: String)
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

public class CanAssociateThingErrorResolver : ErrorResolver {
    public typealias T = CanAssociateThingError
    
    public func fromRequiresReloginError(debugMessage: String) -> CanAssociateThingError {
        return .requiresRelogin(debugMessage: debugMessage)
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> CanAssociateThingError {
        return .invalidParameters(debugMessage: debugMessage)
    }
    
    public func fromGeneralError(debugMessage: String) -> CanAssociateThingError {
        return .generalError(debugMessage: debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> CanAssociateThingError {
        return .connectivityError(debugMessage:debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> CanAssociateThingError? {
        return nil
    }
}





extension CanAssociateThingError: CopilotLocalizedError {
    public func errorPrefix() -> String {
        return "Can Associate Thing"
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
