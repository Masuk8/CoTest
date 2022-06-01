//
//  ThingsService.swift
//  Things
//
//  Created by Yulia Felberg on 29/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import Moya

enum ThingsService {
    case getAssociatedSingleThing(physicalID: String)
    case getAssociatedThings
    case associateThing(firmware: String, model: String, physicalID: String)
    case canAssociateThing(physicalID: String)
    case disassociateThing(physicalID: String)
    case updateAssociatedThing(physicalID: String, firmware: String?, name: String?, customSettings: [String : Any]?, thingStatus: ThingStatus?)
}

extension ThingsService: TargetType, AccessTokenAuthorizable {
    
    private struct Consts {
        static let thingsPath = "\(NetworkParameters.shared.apiVersion)/things/"
        static let associatePathSuffix = "associate"
        static let disassociatePathSuffix = "dissociate/"
        static let canAssociatePathSuffix = "canAssociate/"
    }
    
    var baseURL: URL {
        return NetworkParameters.shared.baseURL
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var path: String {
        switch self {
        case .getAssociatedSingleThing(physicalID: let thingId):
            return Consts.thingsPath + thingId
        case .getAssociatedThings:
            return Consts.thingsPath
        case .associateThing(firmware: _, model: _, physicalID: _):
            return Consts.thingsPath + Consts.associatePathSuffix
        case .updateAssociatedThing(physicalID: let id, firmware: _, name: _, customSettings: _, thingStatus: _):
            return Consts.thingsPath + id
        case .disassociateThing(let physicalID):
            return Consts.thingsPath + Consts.disassociatePathSuffix+physicalID
        case .canAssociateThing(_):
            return Consts.thingsPath + Consts.canAssociatePathSuffix
        }
    }
    
    var method: Moya.Method  {
        switch self {
        case .getAssociatedSingleThing(physicalID: _):
            fallthrough
        case .getAssociatedThings:
            return .get
        case .associateThing(firmware: _, model: _, physicalID: _):
            fallthrough
        case .updateAssociatedThing(physicalID: _, firmware: _, name: _, customSettings: _, thingStatus: _):
            return .post
        case .disassociateThing(_):
            return .post
        case .canAssociateThing(_):
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAssociatedSingleThing(physicalID: let id):
            return ThingServiceParamsInterpreter.convertGetThingParamsToDictionary(thingID: id)
        case .getAssociatedThings:
            return nil
        case .associateThing(firmware: let firmware, model: let model, physicalID: let physicalID):
            return ThingServiceParamsInterpreter.convertAssociateThingParamsToDictionary(firmware: firmware, model: model, physicalID: physicalID)
        case .updateAssociatedThing(physicalID: _, firmware: let firmware, name: let name, customSettings: let customSettings, thingStatus: let thingStatus):
            return ThingServiceParamsInterpreter.convertUpdateThingParamsToDictionary(firmware: firmware, name: name, customSettings: customSettings, thingStatus: thingStatus)
        case .disassociateThing( _):
            return nil
        case .canAssociateThing(let physicalID):
            return ThingServiceParamsInterpreter.convertCanAssociateThingParamsToDictionary(thingID: physicalID)
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getAssociatedSingleThing(physicalID: _):
            fallthrough
        case .getAssociatedThings:
            fallthrough
        case .canAssociateThing(_):
            return URLEncoding.default
        case .associateThing(firmware: _, model: _, physicalID: _):
            fallthrough
        case .disassociateThing( _):
            fallthrough
        case
            .updateAssociatedThing(physicalID: _, firmware: _, name: _, customSettings: _, thingStatus: _):
            return JSONEncoding.default
        
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
