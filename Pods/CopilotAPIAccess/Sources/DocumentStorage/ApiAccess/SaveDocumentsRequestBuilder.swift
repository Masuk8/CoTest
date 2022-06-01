//
//  SaveDocumentsRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Michael Noy on 09/07/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

public class SaveDocumentsRequestBuilder: RequestBuilder<[String:String], SaveDocumentsError>{
    
    private var documentStorageInteractable: DocumentStorageInteractable
    private var documents: [String:String?] = [:]
      
    init(documentStorageInteractable: DocumentStorageInteractable) {
        self.documentStorageInteractable = documentStorageInteractable
        super.init()
    }
    
    public func addDoucment(key: String, document: String?) -> SaveDocumentsRequestBuilder{
        documents[key] = document
        return self;
    }
      
    override public func build() -> RequestExecuter<[String:String], SaveDocumentsError> {
        return SaveDocumentsRequestExecuter(documentStorageInteractable: documentStorageInteractable, documents: documents)
    }
}
