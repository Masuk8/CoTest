//
//  NullUpdateMeDetailsRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 29/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

typealias NullUpdateMeRequestStepBuilderType = UpdateMeRequestStepBuilderType & NullRequestBuilder<UserMe, UpdateUserDetailsError>

class NullUpdateMeDetailsRequestBuilder: NullUpdateMeRequestStepBuilderType {

    func with(firstname: String) -> UpdateMeDetailsRequestBuilderType {
        return self
    }
    
    func with(lastname: String) -> UpdateMeDetailsRequestBuilderType {
        return self
    }
    
    func with<T>(customValue value: T, forKey key: String) -> UpdateMeDetailsRequestBuilderType where T : Encodable {
        return self
    }
    
    func removeCustomValue(forKey key: String) -> UpdateMeDetailsRequestBuilderType {
        return self
    }
}
