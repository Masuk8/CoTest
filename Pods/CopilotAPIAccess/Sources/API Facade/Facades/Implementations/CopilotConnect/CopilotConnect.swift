//
//  CopilotConnect.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 28/05/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public class CopilotConnect: CopilotConnectAccess {

    public let app: AppAPIAccess
    public let auth: AuthAPIAccess
    public let user: UserAPIAccess
    public let thing: ThingAPIAccess
    
    public var defaultAuthProvider: AuthenticationProvider {
        return dependencies.authenticationProvider
    }
    private let dependencies: ConnectDependencies
        
    private static func defaultDependencies(reporter: ReportAPIAccess, configurationProvider: ConfigurationProvider, sessionObserver: SessionLifeTimeObserver, sequentialExecutionHelper: MoyaSequentialExecutionHelper) -> ConnectDependencies {
        let authenticationServiceInteraction = AuthenticationServiceInteraction(sessionObserver: sessionObserver, sequentialExecutionHelper: sequentialExecutionHelper)
        let userServiceInteraction = UserServiceInteraction(authenticationProvider: authenticationServiceInteraction, configurationProvider: configurationProvider, sequentialExecutionHelper: sequentialExecutionHelper)
        let configurationServiceInteraction = SystemConfigurationServiceInteraction(sequentialExecutionHelper: sequentialExecutionHelper)
        let thingsServiceInteraction = ThingsServiceInteraction(authenticationProvider: authenticationServiceInteraction, sequentialExecutionHelper: sequentialExecutionHelper)
        
        return ConnectDependencies(authenticationServiceInteraction: authenticationServiceInteraction,
                                   authenticationProvider: authenticationServiceInteraction,
                                   userServiceInteraction: userServiceInteraction,
                                   configurationServiceInteraction: configurationServiceInteraction,
                                   thingsServiceInteraction: thingsServiceInteraction,
                                   reporter: reporter,
                                   configurationProvider: configurationProvider
        )
    }
    
    init(authenticationProviderContainer: AuthenticationProviderContainer?, reporter: ReportAPIAccess, configurationProvider: ConfigurationProvider, sessionObserver: SessionLifeTimeObserver, sequentialExecutionHelper: MoyaSequentialExecutionHelper) {
        let dependencies = CopilotConnect.defaultDependencies(reporter: reporter, configurationProvider: configurationProvider, sessionObserver: sessionObserver, sequentialExecutionHelper: sequentialExecutionHelper)
        self.dependencies = dependencies
        
        app = ApplicationAPI(dependencies: dependencies)
        auth = AuthAPI(dependencies: dependencies)
        user = UserAPI(dependencies: dependencies)
        thing = ThingAPI(dependencies: dependencies)
        
        authenticationProviderContainer?.authenticationProvider = dependencies.authenticationProvider
    }
}
