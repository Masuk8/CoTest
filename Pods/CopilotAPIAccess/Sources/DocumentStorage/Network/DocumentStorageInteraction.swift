//
//  DocumentStorageInteraction.swift
//  CopilotAPIAccess
//
//  Created by Michael Noy on 25/06/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

typealias FetchDocumentKeysClosure = (Response<DocumentKeys, FetchDocumentKeysError>) -> Void
typealias FetchDocumentsClosure = (Response<[String:String], FetchDocumentsError>) -> Void
typealias SaveDocumentsClosure = (Response<[String:String], SaveDocumentsError>) -> Void

protocol DocumentStorageInteractable{
    func fetchDocumentKeys(fetchDocumentKeysClosure: @escaping FetchDocumentKeysClosure)
    func fetechDocuments(keys: [String], fetchDocumentsClosure: @escaping FetchDocumentsClosure)
    func saveDocuments(documents: [String:String?], saveDocumentsClosure: @escaping SaveDocumentsClosure)
}

internal class DocumentStorageInteraction{
    fileprivate var authenticatedRequestExecutor: AuthenticatedRequestExecutor<DocumentStorageService>
    
    init(authenticationProvider: AuthenticationProvider, sequentialExecutionHelper: MoyaSequentialExecutionHelper){
        authenticatedRequestExecutor = AuthenticatedRequestExecutor<DocumentStorageService>(authenticationProvider: authenticationProvider, sequentialExecutionHelper: sequentialExecutionHelper)
    }
}

//MARK: - InAppServiceInteractable
extension DocumentStorageInteraction : DocumentStorageInteractable{
    
    func fetchDocumentKeys(fetchDocumentKeysClosure: @escaping FetchDocumentKeysClosure) {
    
        authenticatedRequestExecutor.executeRequest(target: DocumentStorageService.getKeys) {[weak self] (requestExecutorResponse) in
            if let weakSelf = self{
                weakSelf.handleFetchDocumentKeysResult(requestExecutorResponse, closure: fetchDocumentKeysClosure)
            }else{
                ZLogManagerWrapper.sharedInstance.logError(message: "cannot handle response getDocumentKeys because self is nil")
            }
        }
    }
    
    func fetechDocuments(keys: [String], fetchDocumentsClosure: @escaping FetchDocumentsClosure) {
        let getDocuments = DocumentStorageService.getDocuments(keys: keys)
        authenticatedRequestExecutor.executeRequest(target: getDocuments) {[weak self] (requestExecutorResponse) in
            if let weakSelf = self{
                weakSelf.handleFetchDocumentsResult(requestExecutorResponse, closure: fetchDocumentsClosure)
            }else{
                ZLogManagerWrapper.sharedInstance.logError(message: "cannot handle response fetechDocuments because self is nil")
            }
        }
    }
    
    func saveDocuments(documents: [String : String?], saveDocumentsClosure: @escaping SaveDocumentsClosure) {
        let documentApiObject = DocumentsApiObject(fromSimpleMap: documents)
        let saveDocuments = DocumentStorageService.patchDocuments(documents: documentApiObject)
        authenticatedRequestExecutor.executeRequest(target: saveDocuments) { [weak self] (requestExecutorResponse) in
            if let weakSelf = self {
                weakSelf.handleSaveDocumentsResult(requestExecutorResponse, closure: saveDocumentsClosure)
            }else{
                ZLogManagerWrapper.sharedInstance.logError(message: "cannot handle response saveDocuments because self is nil")
            }
        }
    }
    
    private func handleFetchDocumentKeysResult(_ response: RequestExecutorResponse, closure: FetchDocumentKeysClosure){
        var fetchDocumentsKeysResponse: Response<DocumentKeys, FetchDocumentKeysError>
        
        switch response {
        case .failure(error: let serverError):
            fetchDocumentsKeysResponse = .failure(error: FetchDocumentKeysErrorResolver().resolve(serverError))
            
        case .success(payload: let dictionary):
            if let documentKeys = DocumentKeys(withDictionary: dictionary) {
                fetchDocumentsKeysResponse = .success(documentKeys)
            } else{
                fetchDocumentsKeysResponse = .failure(error: .generalError(debugMessage: "Failed creating keys from dictionary"))
            }
        }
        closure(fetchDocumentsKeysResponse)
    }
    
    private func handleFetchDocumentsResult(_ response: RequestExecutorResponse, closure: FetchDocumentsClosure){
        var fetchDocumentsResult: Response<[String:String], FetchDocumentsError>
        
        switch response {
        case .failure(error: let serverError):
            fetchDocumentsResult = .failure(error: FetchDocumentsErrorResolver().resolve(serverError))
            
        case .success(payload: let dictionary):
            fetchDocumentsResult = .success(DocumentsApiObject(withDictionary: dictionary).documents)
        }
        closure(fetchDocumentsResult)
    }
    
    private func handleSaveDocumentsResult(_ response: RequestExecutorResponse, closure: SaveDocumentsClosure){
        var saveDocumentResult: Response<[String:String], SaveDocumentsError>
        
        switch response {
        case .failure(error: let serverError):
            saveDocumentResult = .failure(error: SaveDocumentsErrorResolver().resolve(serverError))
            
        case .success(payload: let dictionary):
            saveDocumentResult = .success(DocumentsApiObject(withDictionary: dictionary).documents)
        }
        closure(saveDocumentResult)
    }
}
