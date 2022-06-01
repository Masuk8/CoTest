//
//  DocumentKeysResponse.swift
//
//  Created by Michael Noy on 07/07/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

public class DocumentKeys{
    
    public let keys: [String]
    
    init?(withDictionary dictionary: [String: Any]){
        var allKeys:[String] = []
        if let documents = dictionary["documents"] as? [[String:String]]{
            for document in documents{
                for(_, value) in document{
                    allKeys.append(value)
                }
            }
        }
        keys = allKeys
    }
}
