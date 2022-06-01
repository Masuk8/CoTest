//
//  UpgradeCheckError.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 11/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public enum CheckAppVersionStatusError: CopilotError {
    static func generalError(message: String) -> CheckAppVersionStatusError {
        return .generalError(debugMessage: message)
    }
    
    case appVersionBadFormat(debugMessage: String)
    case connectivityError(debugMessage: String)
    case generalError(debugMessage: String)
}

extension CheckAppVersionStatusError : CopilotLocalizedError{
    public func errorPrefix() -> String {
        return "CheckAppVersionStatus"
    }
    
    public var localizedDescription: String{
        switch(self){
        case .appVersionBadFormat(_):
            return  toString("application version has a bad format")
        case .connectivityError(let debugMessage):
            return connectivityErrorMessage(debugMessage: debugMessage)
        case .generalError(let debugMessage):
            return generalErrorMessage(debugMessage: debugMessage)
        }
    }
}

public class CheckAppVersionStatusErrorResolver : ErrorResolver{
    public func fromRequiresReloginError(debugMessage: String) -> CheckAppVersionStatusError {
        return .generalError(debugMessage: "Unexpected unauthorized exception")
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> CheckAppVersionStatusError {
        return .appVersionBadFormat(debugMessage: debugMessage)
    }
    
    public func fromGeneralError(debugMessage: String) -> CheckAppVersionStatusError {
        return .generalError(debugMessage:debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> CheckAppVersionStatusError {
        return .connectivityError(debugMessage: debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> CheckAppVersionStatusError? {
        return nil
    }
    
    public typealias T = CheckAppVersionStatusError
}
