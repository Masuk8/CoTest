//
//  CanAssociateResponse.swift
//  CopilotAPIAccess
//
//  Created by Adaya on 22/01/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger


public class CanAssociateResponse{
    let isAssociationApproved: Bool
    let rejectionReasons: [RejectReason]
    
    fileprivate struct Constants {
        static let associationApprovedKey = "associationApproved"
        static let rejectCodesKey = "rejectCodes"
        static let rejectCodeKey = "rejectCode"
    }
    /*
     {
     "associationApproved": true,
     "rejectCodes": [
     {
     "rejectCode": "string"
     }
     ]
     }
     */
    
    public init (){
        isAssociationApproved = true
        rejectionReasons = []
    }
    
    public init?(withDictionary dictionary: [String: Any]) {
        guard let associationApproved = dictionary[Constants.associationApprovedKey] as? Bool else {
            ZLogManagerWrapper.sharedInstance.logWarning(message: "unable to create CanAssociateResponse from dictionary. associationApproved value is missing")
            return nil
        }
        
        if let rejectCodes = dictionary[Constants.rejectCodesKey] as? [[String: Any]] {
            var rejectReasons = [RejectReason]()
            rejectCodes.forEach({ (rejectCodeDict) in
                if let code = rejectCodeDict[Constants.rejectCodeKey] as? String {
                    rejectReasons.append(RejectReason.fromValue(value: code))
                }
                else{
                    ZLogManagerWrapper.sharedInstance.logWarning(message: "Failed parsing error reason response to a known value: \(rejectCodeDict)")
                    rejectReasons.append(.Unknown)
                }
            })
            
            self.rejectionReasons = rejectReasons
        }
        else{
            self.rejectionReasons = []
        }
        self.isAssociationApproved = associationApproved
    }

}

extension CanAssociateResponse: CustomStringConvertible {
    
    public var description: String {
        return "isAssociationApproved: \(isAssociationApproved); errors: \(rejectionReasons)"
    }
}

