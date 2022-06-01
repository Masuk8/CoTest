//
//  FetchDocumentRequestExecutor.swift
//  ZemingoBLELayer
//
//  Created by Michael Noy on 07/07/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

public class FetchDocumentsRequestExecuter: RequestExecuter<[String:String], FetchDocumentsError> {
    
    private let documentStorageInteractable: DocumentStorageInteractable

    private let keys: [String]

    init(documentStorageInteractable: DocumentStorageInteractable, keys: [String]) {
        self.documentStorageInteractable = documentStorageInteractable
        self.keys = keys
        super.init()
    }
    
    override public func execute(_ closure: @escaping (Response<[String:String], FetchDocumentsError>) -> Void) {
        var allValid = true
        for (key) in self.keys {
            let matchArray = key.matches(for: "^[a-zA-Z0-9_-]*$")
            if (matchArray.count == 0){
                allValid = false
            }
          }
          
        if(allValid){
            self.documentStorageInteractable.fetechDocuments(keys: keys, fetchDocumentsClosure: closure)
        } else {
            let saveDocumentResult: Response<[String:String], FetchDocumentsError> = .failure(error: .documentKeyIsNotAllowed(debugMessage: "One or more of the documents keys are not allowed"))
            closure(saveDocumentResult)
        }
    }
}
