//
//  FetchDocumentKeys.swift
//  ZemingoBLELayer
//
//  Created by Michael Noy on 07/07/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation
public class FetchDocumentKeysRequestBuilder: RequestBuilder<DocumentKeys, FetchDocumentKeysError> {
    
    private let documentStorageInteraction: DocumentStorageInteractable

    init(documentStorageInteraction: DocumentStorageInteractable) {
        self.documentStorageInteraction = documentStorageInteraction
        super.init()
    }
    
    public override func build() -> RequestExecuter<DocumentKeys,FetchDocumentKeysError> {
        return FetchDocumentKeysRequestExecuter(documentStorageInteraction: documentStorageInteraction)
    }
}
