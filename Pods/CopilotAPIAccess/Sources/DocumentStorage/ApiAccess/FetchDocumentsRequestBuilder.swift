//
//  FetchDocumentsRquestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Michael Noy on 09/07/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

public class FetchDocumentsRequestBuilder : RequestBuilder<[String:String], FetchDocumentsError> {
    
    private var documentStorageInteractable: DocumentStorageInteractable
    private var keys: [String]
    
    init(documentStorageInteractable: DocumentStorageInteractable) {
        self.documentStorageInteractable = documentStorageInteractable
        self.keys = []
        super.init()
    }
    
    public func addKey(key: String) -> FetchDocumentsRequestBuilder{
        self.keys.append(key)
        return self
    }
    
    override public func build() -> RequestExecuter<[String:String], FetchDocumentsError> {
        return FetchDocumentsRequestExecuter(documentStorageInteractable: documentStorageInteractable, keys: keys)
    }
}
