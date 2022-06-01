//
//  RejectReason.swift
//  CopilotAPIAccess
//
//  Created by Adaya on 22/01/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public enum RejectReason{
    case ThingAlreadyAssociated
    case ThingNotAllowed
    case Unknown
    
    fileprivate struct Consts{
        static let thingAlreadyAssociated = "thingAlreadyAssociated"
        static let thingNotAllowed = "thingNotAllowed"
    }
    
    static func fromValue(value: String) -> RejectReason{
        switch value{
        case  Consts.thingAlreadyAssociated:
            return .ThingAlreadyAssociated
        case Consts.thingNotAllowed:
            return .ThingNotAllowed
        default:
            ZLogManagerWrapper.sharedInstance.logWarning(message: "Failed converting \(value) to a RejectReason. fallbacking to Unknown")
            return .Unknown
        }
    }
    //
    static func fromValue(value: String, ignorePrefix: String) -> RejectReason{
        if !value.hasPrefix(ignorePrefix){
            return .Unknown
        }
        let suffix = String(value.dropFirst(ignorePrefix.count))
        return fromValue(value: suffix);
    }
}
