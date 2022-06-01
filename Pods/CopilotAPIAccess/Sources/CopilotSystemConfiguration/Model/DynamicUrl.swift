//
//  DynamicUrl.swift
//  SystemConfigurationComponent
//
//  Created by Yulia Felberg on 22/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public struct DynamicUrl {
    public let url: URL
    public let version: String
    
    public var description: String {
        return Constants.urlKey + ": " + url.path + ", " + Constants.versionKey + ": " + version.description
    }
    
    private struct Constants {
        static let urlKey = "url"
        static let versionKey = "version"
    }
    
    //MARK: Init
    
    private init() {
        url = URL(fileURLWithPath: "")
        version = ""
    }

    init?(withDictionary dictionary: [String: Any]) {
        guard let urlString = dictionary[Constants.urlKey] as? String,
            let version = dictionary[Constants.versionKey] as? Int else {
            ZLogManagerWrapper.sharedInstance.logError(message: "unable to create LegalDocument from dictionary. URL or version are missing")
            return nil
        }
        
        guard let url = URL(string: urlString) else {
            ZLogManagerWrapper.sharedInstance.logError(message: "unable to create URL from string: \(urlString)")

            return nil
        }
        
        self.url = url
        self.version = String(version)
    }
}

extension DynamicUrl: Equatable {
    
    public static func == (lhs: DynamicUrl, rhs: DynamicUrl) -> Bool {
        return lhs.url == rhs.url && lhs.version == rhs.version
    }
}
