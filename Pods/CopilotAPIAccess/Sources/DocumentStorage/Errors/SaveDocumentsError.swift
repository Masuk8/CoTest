//
//  FetchDocumentKeysError.swift
//  ZemingoBLELayer
//
//  Created by Michael Noy on 07/07/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

public enum SaveDocumentsError: Error {
    case documentKeyIsNotAllowed(debugMessage: String)
    case serviceUnavailable(debugMessage: String)
    case documentNotAllowed(debugMessage: String)
    case requiresRelogin(debugMessage: String)
    case generalError(debugMessage: String)
    case connectivityError(debugMessage: String)
}

public class SaveDocumentsErrorResolver: ErrorResolver {
    public typealias T = SaveDocumentsError
    
    public func fromRequiresReloginError(debugMessage: String) -> SaveDocumentsError {
        return .requiresRelogin(debugMessage: debugMessage)
    }
    
    public func fromInvalidParametersError(debugMessage: String) -> SaveDocumentsError {
        return .generalError(debugMessage: "Unexpected invalid parameters \(debugMessage)")
    }
    
    public func fromGeneralError(debugMessage: String) -> SaveDocumentsError {
        return .generalError(debugMessage: debugMessage)
    }
    
    public func fromConnectivityError(debugMessage: String) -> SaveDocumentsError {
        return .connectivityError(debugMessage:debugMessage)
    }
    
    public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> SaveDocumentsError? {
        if(statusCode == 403 || statusCode == 404 || statusCode == 502 || statusCode == 503){
            return .serviceUnavailable(debugMessage: message)
        } else if isInvalidParameters(statusCode, reason) {
            return .documentNotAllowed(debugMessage: message)
        } else if isMarkedForDeletion(statusCode, reason) {
           return .requiresRelogin(debugMessage: message)
       }
        return nil
    }
}

