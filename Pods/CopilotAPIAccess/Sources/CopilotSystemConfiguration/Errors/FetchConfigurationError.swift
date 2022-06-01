//
//  FetchConfigurationError.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 11/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public enum FetchConfigurationError: CopilotError {
    static func generalError(message: String) -> FetchConfigurationError {
        return .generalError(debugMessage: message)
    }
    
    case connectivityError(debugMessage: String)
    case generalError(debugMessage: String)
}

extension FetchConfigurationError : CopilotLocalizedError{
    public func errorPrefix() -> String {
        return "Fetch Configuration"
    }
    
    public var localizedDescription: String{
        switch(self){
        case .connectivityError(let debugMessage):
            return connectivityErrorMessage(debugMessage: debugMessage)
        case .generalError(let debugMessage):
            return generalErrorMessage(debugMessage: debugMessage)
        }
    }
}

public class FetchConfigurationErrorResolver : ErrorResolver{
    public func fromRequiresReloginError(debugMessage: String) -> FetchConfigurationError {
        return .generalError(debugMessage: "Unexpected unauthorized exception")
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> FetchConfigurationError {
        return .generalError(debugMessage: "Unexpected invalidParameters exception")
    }
    
    public func fromGeneralError(debugMessage: String) -> FetchConfigurationError {
        return .generalError(debugMessage:debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> FetchConfigurationError {
        return .connectivityError(debugMessage: debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> FetchConfigurationError? {
        return nil
    }
    
    public typealias T = FetchConfigurationError
}
