//
//  UserServiceParamsInterpreter.swift
//  Users
//
//  Created by Yulia Felberg on 30/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

internal struct UserServiceParamsInterpreter {
    
    private struct Constants {
        static let infoKey = "info"
        static let customSettingsKey = "customSettings"
        
        static let copilotSdkVersionKey = "copilotSdkVersion"
        
        static let pnsDetailsKey = "pushNotificationDetails"
        static let isSandboxKey = "isSandbox"
        static let tokenKey = "token"
    }
    
    internal static func convertUpdateUserParamsToDictionary(userInfo: UserInfo?, customSettings: [String: Any]?) -> [String: Any] {
        var parameters = [String: Any]()
        
        if let userInfo = userInfo {
            parameters[Constants.infoKey] = userInfo.convertToDictionary()
        }
        else {
            ZLogManagerWrapper.sharedInstance.logInfo(message: "userInfo is empty")
        }
        
        if let customSettings = customSettings {
            parameters[Constants.customSettingsKey] = customSettings
        }
        
        return parameters
    }
    
    internal static func convertCurrentDeviceParamsToDictionary(copilotSdkVersion: String, pnsToken: Data, isSandbox: Bool, deviceDetails: [String: Any]) -> [String: Any] {
        
        //Convert device token
        let pnsTokenString = pnsToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        var params = deviceDetails
        
        //Add additional params
        params[Constants.copilotSdkVersionKey] = copilotSdkVersion
        params[Constants.pnsDetailsKey] = [
            Constants.isSandboxKey: isSandbox,
            Constants.tokenKey: pnsTokenString
        ]
        
        return params
    }
}
