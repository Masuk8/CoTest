//
//  DocumentStorageManager.swift
//  CopilotAPIAccess
//
//  Created by Michael Noy on 08/07/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

class DoucmentStorageManager : DocumentStorageAPIAccess{
    
    private let documentStorageInteractable: DocumentStorageInteractable
    
    init(authenticationProvider: AuthenticationProvider, sequentialExecutionHelper: MoyaSequentialExecutionHelper){
        self.documentStorageInteractable = DocumentStorageInteraction(authenticationProvider: authenticationProvider, sequentialExecutionHelper: sequentialExecutionHelper)
    }
    
    func fetchKeys() -> RequestBuilder<DocumentKeys, FetchDocumentKeysError> {
        return FetchDocumentKeysRequestBuilder(documentStorageInteraction: documentStorageInteractable)
    }
    
    func fetchDocuments() -> FetchDocumentsRequestBuilder {
        return FetchDocumentsRequestBuilder(documentStorageInteractable: documentStorageInteractable)
    }
    
    func saveDocuments() -> SaveDocumentsRequestBuilder {
        return SaveDocumentsRequestBuilder(documentStorageInteractable: documentStorageInteractable)
    }
}
