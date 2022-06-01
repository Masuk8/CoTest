//
//  CopilotTokenProvider.swift
//  ZemingoBLELayer
//
//  Created by Revital Pisman on 20/06/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public typealias GenerateUserAuthKeyClosure = (Response<String, GenerateUserAuthKeyError>) -> Void

public protocol CopilotTokenProvider {
    
    func generateUserAuthKey(for userId: String, withClosure closure: @escaping GenerateUserAuthKeyClosure)
}
