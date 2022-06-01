//
//  UserInfo.swift
//  Users
//
//  Created by Yulia Felberg on 25/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public struct UserInfo {
    public let firstName: String?
    public let lastName: String?
    
    fileprivate struct Constants {
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
    }
    
    init?(withDictionary dictionary: [String: Any]) {
        self.firstName = dictionary[Constants.firstNameKey] as? String
        self.lastName = dictionary[Constants.lastNameKey] as? String
    }
    
    public init(firstName: String?, lastName: String?) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    public init(){
        firstName = nil
        lastName = nil
    }
    
    internal func convertToDictionary() -> [String: Any]{
        var userInfoDict = [Constants.firstNameKey: "", Constants.lastNameKey: ""]
        
        if let firstName = self.firstName {
            userInfoDict[Constants.firstNameKey] = firstName
        }
        
        if let lastName = self.lastName {
            userInfoDict[Constants.lastNameKey] = lastName
        }
        
        return userInfoDict
    }
}

extension UserInfo: CustomStringConvertible {
    
    public var description: String {
        return "\(Constants.firstNameKey):\(String(describing: firstName)), \(Constants.lastNameKey): \(String(describing: lastName))"
    }
}
