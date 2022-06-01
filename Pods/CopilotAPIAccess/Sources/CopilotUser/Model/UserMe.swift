//
//  UserMe.swift
//  User
//
//  Created by Adaya on 17/12/2017.
//  Copyright © 2017 Falcore. All rights reserved.
//

import Foundation
import CopilotLogger

public class UserMe {
    
    public enum Constants {
        static let userDetails = "userDetails"
        static let accountStatus = "accountStatus"
    }
    
    public let userDetails: User
    public let accountStatus: AccountStatus
    
    init?(withDictionary dictionary: [String: Any]) {
        guard let details = dictionary[Constants.userDetails] as? [String: Any], let account = dictionary[Constants.accountStatus] as? [String: Any] else {
            ZLogManagerWrapper.sharedInstance.logError(message: "UserMe did not contain an entry for userDetails or accountStatus")
            return nil
        }
        if let user =  User(withDictionary: details){
            userDetails = user
        }
        else{
            return nil
        }
        if let status = AccountStatus(withDictionary: account){
            accountStatus = status
        }
        else {
            return nil
        }
    }
    
}

extension UserMe: CustomStringConvertible {
    
    public var description: String{
        return "User: \(userDetails); Status: \(accountStatus)"
    }
}
