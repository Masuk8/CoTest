//
//  SystemConfigurationService.swift
//  SystemConfigurationComponent
//
//  Created by Yulia Felberg on 22/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import Moya

private struct ParameterProvider {
    
    internal struct serverParmetertKeys {
        static let OSType = "osType"
        static let appVersion = "applicationVersion"
    }
    
    internal struct generalParameters {
        static let iOS = "IOS"
    }
}

enum SystemConfigurationService {
    case checkIfAppUpgradeRequired(appVersion: String)
    case getConfiguration
}

extension SystemConfigurationService: TargetType {
    private struct Consts {
        
        static let systemPath = "\(NetworkParameters.shared.apiVersion)/system/"
        
        static let getConfiguration = Consts.systemPath + "config"
        static let appVersionStatusPath = Consts.systemPath + "appVersionStatus"
    }
    
    var baseURL: URL {
        return NetworkParameters.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .checkIfAppUpgradeRequired(appVersion: _):
            return Consts.appVersionStatusPath
        case .getConfiguration:
            return Consts.getConfiguration
        }
    }
    
    var method: Moya.Method  {
        switch self {
        case .checkIfAppUpgradeRequired(appVersion: _), .getConfiguration:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .checkIfAppUpgradeRequired(appVersion: let appVersion):
            return [ParameterProvider.serverParmetertKeys.OSType : ParameterProvider.generalParameters.iOS, ParameterProvider.serverParmetertKeys.appVersion : appVersion]
        case .getConfiguration:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .checkIfAppUpgradeRequired(appVersion: _), .getConfiguration:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        if let params = parameters {
            return .requestParameters(parameters: params, encoding: parameterEncoding)
        } else {
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
