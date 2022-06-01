//
//  Manage.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 08/05/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public class Manage {
    
    public let yourOwn: YourOwnAccess
    public let copilotConnect: CopilotConnectAccess
    
    init(authenticationProviderContainer: AuthenticationProviderContainer, reporter: ReportAPIAccess, configurationProvider: ConfigurationProvider, sessionObserver: SessionLifeTimeObserver, sequentialExecutionHelper: MoyaSequentialExecutionHelper) {
        if configurationProvider.manageType == .yourOwn {
            yourOwn = YourOwn(authenticationProviderContainer: authenticationProviderContainer, reporter: reporter, sessionObserver: sessionObserver)
            copilotConnect = NullCopilotConnect()
        } else {
            yourOwn = NullYourOwn()
            copilotConnect = CopilotConnect(authenticationProviderContainer: authenticationProviderContainer, reporter: reporter, configurationProvider: configurationProvider, sessionObserver: sessionObserver, sequentialExecutionHelper: sequentialExecutionHelper)
        }
    }
    
}
