//
//  ExternalService.swift
//  ZemingoBLELayer
//
//  Created by Revital Pisman on 19/06/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
import Moya

internal enum ExternalService {
    case me
}

extension ExternalService: TargetType, AccessTokenAuthorizable {
    
    private struct Consts {
        
        static let systemPath = "\(NetworkParameters.shared.apiVersion)/users/"
        
        static let mePath = Consts.systemPath + "external_me"
    }
    
    public var baseURL: URL {
        return NetworkParameters.shared.baseURL
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    public var path: String {
        switch self {
        case .me:
            return Consts.mePath
        }
    }
    
    public var method: Moya.Method  {
        switch self {
        case .me:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .me:
            return nil
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .me:
            return URLEncoding.default
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
