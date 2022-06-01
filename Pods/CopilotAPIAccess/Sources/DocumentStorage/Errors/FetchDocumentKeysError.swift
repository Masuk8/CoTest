//
//  FetchDocumentKeysError.swift
//  ZemingoBLELayer
//
//  Created by Michael Noy on 07/07/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

public enum FetchDocumentKeysError: Error {
    case serviceUnavailable(debugMessage: String)
    case requiresRelogin(debugMessage: String)
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

public class FetchDocumentKeysErrorResolver: ErrorResolver {
    public typealias T = FetchDocumentKeysError
    
    public func fromRequiresReloginError(debugMessage: String) -> FetchDocumentKeysError {
        return .requiresRelogin(debugMessage: debugMessage)
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> FetchDocumentKeysError {
        return .generalError(debugMessage: "Unexpected invalid parameters \(debugMessage)")
    }
    
    public func fromGeneralError(debugMessage: String) -> FetchDocumentKeysError {
        return .generalError(debugMessage: debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> FetchDocumentKeysError {
        return .connectivityError(debugMessage:debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> FetchDocumentKeysError? {
        if isMarkedForDeletion(statusCode, reason){
            return .requiresRelogin(debugMessage: message)
        }else  if(statusCode == 403 || statusCode == 404 || statusCode == 502 || statusCode == 503){
            return .serviceUnavailable(debugMessage: message)
        }
        
        return nil
    }
}

