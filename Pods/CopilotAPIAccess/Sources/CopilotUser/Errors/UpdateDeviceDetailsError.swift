//
//  UpdateDeviceDetailsError.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 11/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public enum UpdateDeviceDetailsError: Error {
    case invalidParameters(debugMessage: String)
    case requiresRelogin(debugMessage: String)
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

public class UpdateDeviceDetailsErrorResolver : ErrorResolver{
    public typealias T = UpdateDeviceDetailsError
    
    public func fromRequiresReloginError(debugMessage: String) -> UpdateDeviceDetailsError {
        return .requiresRelogin(debugMessage: debugMessage)
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> UpdateDeviceDetailsError {
        return .invalidParameters(debugMessage: debugMessage)
    }
    
    public func fromGeneralError(debugMessage: String) -> UpdateDeviceDetailsError {
        return .generalError(debugMessage: debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> UpdateDeviceDetailsError {
        return .connectivityError(debugMessage:debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> UpdateDeviceDetailsError? {
        return nil
    }
}





extension UpdateDeviceDetailsError: CopilotLocalizedError {
    public func errorPrefix() -> String {
        return "Update Device Details"
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
