//
//  CheckAppVersionRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class CheckAppVersionRequestExecuter: RequestExecuter<AppVersionStatus, CheckAppVersionStatusError> {
    
    typealias Dependencies = HasSystemConfigurationServiceInteraction
    private let dependencies: Dependencies
    
    private let appVersion: String
    
    init(appVersion: String, dependencies: Dependencies) {
        self.appVersion = appVersion
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<AppVersionStatus, CheckAppVersionStatusError>) -> Void) {
        dependencies.configurationServiceInteraction.checkIfUpgradeRequired(appVersion: appVersion, upgradeCheckClosure: closure)
    }
}
