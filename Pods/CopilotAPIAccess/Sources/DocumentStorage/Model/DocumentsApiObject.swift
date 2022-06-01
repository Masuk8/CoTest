//
//  DocumentApiObject.swift
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

public class DocumentsApiObject{
    
    public var documents: [String:String] {
        get {
            var retVal: [String:String] = [:]
            for(key, value) in _documents{
                retVal[key] = value.content
            }
            return retVal
        }
    }
        
    private var _documents: [String: DocumentObject] = [:]
    
    init (withDictionary documentsDict:[String:Any]){
        if let documents =  documentsDict["documents"] as? [String:[String:Any]]{
            for(key, value) in documents {
                _documents[key] = DocumentObject(withDictionary: value)
            }
        }
    }
    init(fromSimpleMap simpleMap:[String:String?]){
        for(key,value) in simpleMap{
            _documents[key] = DocumentObject(withDictionary: ["content":value])
        }
    }
    
    static func toDictionary(documentApiObject: DocumentsApiObject) -> [String:Any]{
        var paramteres: [String:Any] = [:]
        for(key, document) in documentApiObject._documents{
            if let value = DocumentObject.toDictionary(documentApiObject: document){
                paramteres[key] = value
            }
        }
        
        return paramteres
    }
    
    public class DocumentObject{
        fileprivate let content:String?

        init(withDictionary dictrionary:[String:Any]){
            if let content =  dictrionary["content"] as? String? {
                self.content = content
            } else {
                content = nil
            }
        }
        
        static func toDictionary(documentApiObject: DocumentObject) -> [String:String]?{
            if let content = documentApiObject.content {
                return ["content": content]
            }else{
                return nil
            }
        }
    }
}
