//
//  DocumentStorageAPIAccess.swift
//  ZemingoBLELayer
//
//  Created by Michael Noy on 24/06/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

public protocol DocumentStorageAPIAccess: class {
    func fetchKeys() ->  RequestBuilder<DocumentKeys, FetchDocumentKeysError>
    func fetchDocuments() -> FetchDocumentsRequestBuilder
    func saveDocuments() -> SaveDocumentsRequestBuilder
}
