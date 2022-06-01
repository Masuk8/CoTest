//
//  CheckAppVersionRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class CheckAppVersionRequestBuilder: RequestBuilder<AppVersionStatus, CheckAppVersionStatusError> {
    
    typealias Dependencies = HasSystemConfigurationServiceInteraction
    private let dependencies: Dependencies
    
    private let appVersion: String
    
    init(appVersion: String, dependencies: Dependencies) {
        self.appVersion = appVersion
        self.dependencies = dependencies
        super.init()
    }
    
    override func build() -> RequestExecuter<AppVersionStatus, CheckAppVersionStatusError> {
        return CheckAppVersionRequestExecuter(appVersion: appVersion, dependencies: dependencies)
    }
}
