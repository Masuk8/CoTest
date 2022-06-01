//
//  FetchDocumentKeys.swift
//  ZemingoBLELayer
//
//  Created by Michael Noy on 07/07/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation
class FetchDocumentKeysRequestExecuter: RequestExecuter<DocumentKeys, FetchDocumentKeysError> {
    
    private let documentStorageInteraction: DocumentStorageInteractable

    init(documentStorageInteraction: DocumentStorageInteractable) {
        self.documentStorageInteraction = documentStorageInteraction
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<DocumentKeys, FetchDocumentKeysError>) -> Void) {
        self.documentStorageInteraction.fetchDocumentKeys(fetchDocumentKeysClosure: closure)
    }
}
