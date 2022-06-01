//
//  FetchDocumentKeysError.swift
//  ZemingoBLELayer
//
//  Created by Michael Noy on 07/07/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

public enum FetchDocumentsError: Error {
    case documentKeyIsNotAllowed(debugMessage: String)
    case serviceUnavailable(debugMessage: String)
    case requiresRelogin(debugMessage: String)
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

public class FetchDocumentsErrorResolver: ErrorResolver {
    public typealias T = FetchDocumentsError
    
    public func fromRequiresReloginError(debugMessage: String) -> FetchDocumentsError {
        return .requiresRelogin(debugMessage: debugMessage)
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> FetchDocumentsError {
        return .generalError(debugMessage: "Unexpected invalid parameters \(debugMessage)")
    }
    
    public func fromGeneralError(debugMessage: String) -> FetchDocumentsError {
        return .generalError(debugMessage: debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> FetchDocumentsError {
        return .connectivityError(debugMessage:debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> FetchDocumentsError? {
        if isMarkedForDeletion(statusCode, reason){
            return .requiresRelogin(debugMessage: message)
        }else  if(statusCode == 403 || statusCode == 404 || statusCode == 502 || statusCode == 503){
            return .serviceUnavailable(debugMessage: message)
        }
        
        return nil
    }
}

