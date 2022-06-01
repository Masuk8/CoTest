//
//  User.swift
//  Users
//
//  Created by Yulia Felberg on 25/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public class User {
    
    public enum Constants {
        static let idKey = "id"
        static let emailKey = "email"
        static let infoKey = "info"
        static let customSettingsKey = "customSettings"
    }
    
    public let id: String
    public let email: String?
    public var userInfo: UserInfo?
    let serializedCustomSettings: [String: Any]?
    public var customSettingsKeys: [String]? {
        return serializedCustomSettings?.keys.map({ return $0 })
    }
    
    // MARK: - Init
    
    init?(withDictionary dictionary: [String: Any]) {
        guard let idString = dictionary[Constants.idKey] as? String else {
            return nil
        }
        
        id = idString
        email = dictionary[Constants.emailKey] as? String
        
        serializedCustomSettings = dictionary[Constants.customSettingsKey] as? [String: Any]
        if serializedCustomSettings == nil {
            ZLogManagerWrapper.sharedInstance.logInfo(message: "No customSettings for user id: " + id)
        }        
        
        if let userInfo = initUserInfoFromDictionary(dictionary) {
            self.userInfo = userInfo
        }
        else {
            ZLogManagerWrapper.sharedInstance.logInfo(message: "No userInfo for user id: " + id)
            
        }
    }
    
    // MARK: - Private
    
    private func initUserInfoFromDictionary(_ dictionary: [String: Any]) -> UserInfo? {
        if let userInfoDict = dictionary[Constants.infoKey] as? [String: Any] {
            if let userInfo = UserInfo(withDictionary: userInfoDict) {
                return userInfo
            }
            else {
                ZLogManagerWrapper.sharedInstance.logError(message: "Failed to create UserInfo from dictionary")
                return nil
            }
        }
        else {
            ZLogManagerWrapper.sharedInstance.logInfo(message: "No userInfo or it's not a dictionary")
            return nil
        }
    }
    
    // MARK: - Public
    
    public func get<T: Decodable>(key: String, as objectType: T.Type) -> T? {
        guard let val = serializedCustomSettings?[key], !(val is NSNull) else {
            return nil
        }
        
        if val is T {
            return val as? T
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: val, options: [])            
            let object = try JSONDecoder().decode(objectType, from: data)
            return object
        } catch {
            ZLogManagerWrapper.sharedInstance.logError(message: "Failed to decode data for key with error \(error)")
            return nil
        }
    }
    
}

extension User: CustomStringConvertible {
    
    public var description: String {
        return "id: \(id); email: \(email ?? ""); userInfo: \(String(describing: userInfo)); customSettings: \(String(describing: serializedCustomSettings))"
    }
}
