//
//  UpdateMeRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class UpdateMeRequestExecuter: RequestExecuter<UserMe, UpdateUserDetailsError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction
    private let dependencies: Dependencies
    
    private var firstname: String?
    private var lastname: String?
    private let customSettings: [String: Any]
    private let error: UpdateUserDetailsError?
    
    init(firstname: String?,
         lastname: String?,
         customSettings: [String: Any],
         error: UpdateUserDetailsError?,
         dependencies: Dependencies) {
        self.firstname = firstname
        self.lastname = lastname
        self.customSettings = customSettings
        self.error = error
        self.dependencies = dependencies        
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<UserMe, UpdateUserDetailsError>) -> Void) {
        let customSettings: [String:Any]? = self.customSettings.isEmpty ? nil : self.customSettings
        let hasUpdatedUserInfo: Bool = firstname != nil || lastname != nil
        let userInfo =  hasUpdatedUserInfo ? UserInfo(firstName: firstname, lastName: lastname) : nil
        
        if let userId = dependencies.userServiceInteraction.me?.userDetails.id {
            if let error = self.error {
                closure(.failure(error: error))
            } else {
                dependencies.userServiceInteraction.updateUser(id: userId, userInfo: userInfo, customSettings: customSettings, updateUserClosure: closure)
            }
        }
        else {
            
//            executeGetMeRequest(userInfo: userInfo, customSettings: customSettings,shouldRetry: true, closure: closure)
            //Need to call the closure with a failure
            closure(.failure(error: UpdateUserDetailsError.invalidParameters(debugMessage: "please invoke the fetchMe method before trying to update")))
        }
    }
    
    //// this did not work as the self reference was nullified 
//    private func executeGetMeRequest(userInfo: UserInfo?, customSettings: [String:Any]?, shouldRetry: Bool, closure: @escaping (Response<Void, UpdateUserDetailsError>) -> Void) {
//        //There is not yet a user cached, need to call getMe first and then call updateUser
//        if shouldRetry {
//            dependencies.userServiceInteraction.me { [weak self] (result) in
//                if let `self` = self {
//                    switch result {
//                    case .success(let user):
//                        self.dependencies.userServiceInteraction.updateUser(id: user.userDetails.id, userInfo: userInfo, customSettings: customSettings, updateUserClosure: closure)
//                    case .failure(error: _):
//                        self.executeGetMeRequest(userInfo: userInfo, customSettings: customSettings, shouldRetry: false, closure: closure)
//                    }
//                }
//            }
//        }
//        else {
//            //Need to call the closure with a failure
//            closure(.failure(error: UpdateUserDetailsError.invalidParameters(debugMessage: "please invoke the fetchMe method before trying to update")))
//        }
//    }
}
