//
//  DisassociateThingError.swift
//  ZemingoBLELayer
//
//  Created by Adaya on 22/01/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation


public enum DisassociateThingError: CopilotError {
    static func generalError(message: String) -> DisassociateThingError {
        return .generalError(debugMessage: message)
    }
    
    case thingNotFound(debugMessage: String)
    case invalidParameters(debugMessage: String)
    case requiresRelogin(debugMessage: String)
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

public class DisassociateThingErrorResolver : ErrorResolver {
    public typealias T = DisassociateThingError
    
    public func fromRequiresReloginError(debugMessage: String) -> DisassociateThingError {
        return .requiresRelogin(debugMessage: debugMessage)
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> DisassociateThingError {
        return .invalidParameters(debugMessage: debugMessage)
    }
    
    public func fromGeneralError(debugMessage: String) -> DisassociateThingError {
        return .generalError(debugMessage: debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> DisassociateThingError {
        return .connectivityError(debugMessage:debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> DisassociateThingError? {
        if isEntityNotFound(statusCode, reason) {
            return .thingNotFound(debugMessage: message)
        }
        return nil
    }
}





extension DisassociateThingError: CopilotLocalizedError {
    public func errorPrefix() -> String {
        return "Disassociate Thing"
    }
    
    public var errorDescription: String? {
        switch self {
        case .thingNotFound(let debugMessage):
            return toString("thing not found (\(debugMessage)")
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
