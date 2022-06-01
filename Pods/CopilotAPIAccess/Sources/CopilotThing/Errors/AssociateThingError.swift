//
//  AssociateThingError.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 11/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public enum AssociateThingError: CopilotError {
    static func generalError(message: String) -> AssociateThingError {
        return .generalError(debugMessage: message)
    }
    case thingAlreadyAssociated(debugMessage: String)
    case thingNotAllowed(debugMessage: String)
    case invalidParameters(debugMessage: String)
    case requiresRelogin(debugMessage: String)
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

public class AssociateThingErrorResolver : ErrorResolver {
    public typealias T = AssociateThingError
    
    public func fromRequiresReloginError(debugMessage: String) -> AssociateThingError {
        return .requiresRelogin(debugMessage: debugMessage)
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> AssociateThingError {
        return .invalidParameters(debugMessage: debugMessage)
    }
    
    public func fromGeneralError(debugMessage: String) -> AssociateThingError {
        return .generalError(debugMessage: debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> AssociateThingError {
        return .connectivityError(debugMessage:debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> AssociateThingError? {
        if statusCode != 403 {
            return nil
        }
        let rejectReason = RejectReason.fromValue(value: reason, ignorePrefix: "associationFailure.")
         switch rejectReason{
         case .ThingAlreadyAssociated:
            return  .thingAlreadyAssociated(debugMessage: message)
         case .ThingNotAllowed:
            return .thingNotAllowed(debugMessage: message)
         case .Unknown:
            return nil
        }
    }
}





extension AssociateThingError: CopilotLocalizedError {
    public func errorPrefix() -> String {
        return "Associate Thing"
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
        case .thingAlreadyAssociated(let debugMessage):
            return toString("Thing already associated (\(debugMessage)")
        case .thingNotAllowed(let debugMessage):
            return toString("Thing association not allowed (\(debugMessage)")
        }
    }
}
