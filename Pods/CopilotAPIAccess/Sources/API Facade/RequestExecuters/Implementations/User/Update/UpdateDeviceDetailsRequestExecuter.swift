//
//  UpdateDeviceDetailsRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class UpdateDeviceDetailsRequestExecuter: RequestExecuter<Void, UpdateDeviceDetailsError> {
    
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
    
    override func execute(_ closure: @escaping (Response<Void, UpdateDeviceDetailsError>) -> Void) {
		let version = VersionResolver().copilotVersion
        dependencies.userServiceInteraction.updateDeviceDetails(copilotSdkVersion: version, pnsToken: pnsToken, isSandbox: isSandbox, updateCurrentDeviceClosure: closure)
    }
}
