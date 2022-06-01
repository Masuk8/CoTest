//
//  UserService.swift
//  Users
//
//  Created by Yulia Felberg on 25/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import Moya

internal enum UserService {
    case me
    case delete
    case updateUser(id: String, userInfo: UserInfo?, customSettings: [String: Any]?)
    case updateDeviceDetails(copilotSdkVersion: String, pnsToken: Data, isSandbox: Bool, deviceDetails: [String: Any])
}

extension UserService: TargetType, AccessTokenAuthorizable {

    private struct Consts {
        
        static let systemPath = "\(NetworkParameters.shared.apiVersion)/users/"
        
        static let mePath = Consts.systemPath + "me"
        static let updateUserPath = Consts.systemPath
        static let updateDevicePath = Consts.mePath + "/currentDevice"
        static let settingsPathSuffix = "settings"
    }
    
    public var baseURL: URL {
        return NetworkParameters.shared.baseURL
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    public var path: String {
        switch self {
        case .me, .delete:
            return Consts.mePath
        case .updateUser(id: let userId, userInfo: _, customSettings: _):
            return "\(Consts.updateUserPath)\(userId)/\(Consts.settingsPathSuffix)"
        case .updateDeviceDetails(copilotSdkVersion: _, pnsToken: _, isSandbox: _, deviceDetails: _):
            return Consts.updateDevicePath
        }
    }
    
    public var method: Moya.Method  {
        switch self {
        case .me:
            return .get
        case .delete:
            return .delete
        case .updateUser(id: _, userInfo: _, customSettings: _):
            return .post
        case .updateDeviceDetails(copilotSdkVersion: _, pnsToken: _, isSandbox: _, deviceDetails: _):
            return .put
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .me, .delete:
            return nil
        case .updateUser(id: _, userInfo: let userInfo, customSettings: let customSettings):
            return UserServiceParamsInterpreter.convertUpdateUserParamsToDictionary(userInfo: userInfo, customSettings: customSettings)
        case .updateDeviceDetails(let copilotSdkVersion, let pnsToken, let isSandbox, let deviceDetails):
            return UserServiceParamsInterpreter.convertCurrentDeviceParamsToDictionary(copilotSdkVersion: copilotSdkVersion, pnsToken: pnsToken, isSandbox: isSandbox, deviceDetails: deviceDetails)
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .me, .delete:
            return URLEncoding.default
        case .updateUser(id: _, userInfo: _, customSettings: _),
             .updateDeviceDetails(copilotSdkVersion: _, pnsToken: _, isSandbox: _, deviceDetails: _):
            return JSONEncoding.default
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        if let params = parameters {
            return .requestParameters(parameters: params, encoding: parameterEncoding)
        } else {
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}
