//
//  InAppService.swift
//  CopilotAPIAccess
//
//  Created by Michael on 25/06/2020.
//  Copyright © 2020 Copilot. All rights reserved.
//

import Foundation
import Moya
import Alamofire

internal enum DocumentStorageService {
    case getKeys
    case getDocuments(keys: [String])
    case patchDocuments(documents : DocumentsApiObject)
}

extension DocumentStorageService: TargetType, AccessTokenAuthorizable {
    
    private struct Consts {
        static let servicePath = "\(NetworkParameters.shared.apiVersion)/storage"
        static let getKeysPath = servicePath + "/list"
    }
    
    public var baseURL: URL {
        return NetworkParameters.shared.baseURL
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    public var path: String {
        switch self {
        case .getKeys:
            return Consts.getKeysPath
        case .getDocuments(keys: _):
            return Consts.servicePath
        case .patchDocuments(documents: _):
            return Consts.servicePath
        }
    }
    
    public var method: Moya.Method  {
        switch self {
        case .getKeys:
            return .get
        case .getDocuments(keys: _):
            return .get
        case .patchDocuments(documents: _):
            return .patch
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getKeys:
            return nil
        case  .getDocuments(let keys):
            return ["keys" : keys]
        case .patchDocuments(let documents):
            return ["documents": DocumentsApiObject.toDictionary(documentApiObject: documents)]
        }
    
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .getKeys:
            return URLEncoding.default
        case .getDocuments(_):
            return BracketLessGetEncoding()
        case .patchDocuments(_):
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
    
    
    struct BracketLessGetEncoding: ParameterEncoding {
      func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
               var request = try urlRequest.asURLRequest()
               
               guard let parameters = parameters else {return request}
               
               guard let url = request.url else {
                   throw AFError.parameterEncodingFailed(reason: .missingURL)
               }
               
               if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                   let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                   urlComponents.percentEncodedQuery = percentEncodedQuery
                   request.url = urlComponents.url
               }
               return request
           }
    
        private func query(_ parameters: [String: Any]) -> String {
              var components: [(String, String)] = []
              
              for key in parameters.keys.sorted(by: <) {
                  let value = parameters[key]!
                  components += queryComponents(fromKey: key, value: value)
              }
              return components.map { "\($0)=\($1)" }.joined(separator: "&")
          }
          
      private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {

        var components: [(String, String)] = []
          
        if let array = value as? [String] {
            let joined = array.joined(separator: ",")
            components += queryComponents(fromKey: key, value: joined)
        } else {
            components.append((key, "\(value)"))
        }
        return components
    }
    }
}
