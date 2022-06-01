//
//  FetchThingsError.swift
//  Copilot
//
//  Created by Adaya on 17/02/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public enum FetchThingsError: CopilotError {
    static func generalError(message: String) -> FetchThingsError {
        return .generalError(debugMessage: message)
    }
    
    case requiresRelogin(debugMessage: String)
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

public class FetchThingsErrorResolver : ErrorResolver{
    public typealias T = FetchThingsError
    
    public func fromRequiresReloginError(debugMessage: String) -> FetchThingsError {
        return .requiresRelogin(debugMessage: debugMessage)
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> FetchThingsError {
        return .generalError(debugMessage: "Unexpected invalid parameters \(debugMessage)")
    }
    
    public func fromGeneralError(debugMessage: String) -> FetchThingsError {
        return .generalError(debugMessage: debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> FetchThingsError {
        return .connectivityError(debugMessage:debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> FetchThingsError? {
        return nil
    }
}





extension FetchThingsError: CopilotLocalizedError {
    public func errorPrefix() -> String {
        return "Fetch Things"
    }
    
    public var errorDescription: String? {
        switch self {
        case .requiresRelogin(let debugMessage):
            return requiresReloginMessage(debugMessage: debugMessage)
        case .generalError(let debugMessage):
            return generalErrorMessage(debugMessage: debugMessage)
        case .connectivityError(let debugMessage):
            return connectivityErrorMessage(debugMessage: debugMessage)
        }
    }
}
