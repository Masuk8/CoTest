//
//  UpdateDeviceDetailsRequestBuilder.swift
//  ZemingoBLELayer
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class UpdateDeviceDetailsRequestBuilder: RequestBuilder<Void, UpdateDeviceDetailsError> {
    
    typealias Dependencies = HasUserServiceInteraction
    private let dependencies: Dependencies
    
    private let pnsToken: Data
    private let isSandbox: Bool
    
    init(pnsToken: Data, isSandbox: Bool, dependencies: Dependencies) {
        self.pnsToken = pnsToken
        self.isSandbox = isSandbox
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<Void, UpdateDeviceDetailsError> {
        return UpdateDeviceDetailsRequestExecuter(pnsToken: pnsToken, isSandbox: isSandbox, dependencies: dependencies)
    }
}
