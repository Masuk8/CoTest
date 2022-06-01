//
//  SaveDocumentRequestExecuter.swift
//
//  Created by Michael Noy on 07/07/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

class SaveDocumentsRequestExecuter: RequestExecuter<[String:String], SaveDocumentsError> {

    private let documents: [String:String?]
    
    private let documentStorageInteractable: DocumentStorageInteractable
    
    init(documentStorageInteractable: DocumentStorageInteractable, documents: [String:String?]) {
        self.documentStorageInteractable = documentStorageInteractable
        self.documents = documents
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<[String:String], SaveDocumentsError>) -> Void) {
        var allValid = true
        for (key,_) in self.documents {
            let matchArray = key.matches(for: "^[a-zA-Z0-9_-]*$")
            if (matchArray.count == 0){
                allValid = false
            }
          }
          
        if(allValid){
            self.documentStorageInteractable.saveDocuments(documents: documents, saveDocumentsClosure: closure)
        } else {
            let saveDocumentResult: Response<[String:String], SaveDocumentsError> = .failure(error: SaveDocumentsError.documentKeyIsNotAllowed(debugMessage: "One or more of the documents keys are not allowed"))
            closure(saveDocumentResult)
        }
    }
}
