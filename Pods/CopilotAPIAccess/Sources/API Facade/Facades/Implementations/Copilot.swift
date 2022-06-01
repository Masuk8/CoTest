//
//  Copilot.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 08/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public class Copilot {
    
    public static let instance: Copilot = Copilot()
    public let report: ReportAPIAccess
    public let manage: Manage
    public let inAppMessages: InAppManagerAPIAccess
    public let documentStorage: DocumentStorageAPIAccess

    private let sessionNotifier = SessionNotifier()
    
    private init() {

        let bundleConfigurationProvider: ConfigurationProvider = BundleConfigurationProvider()
        CopilotConfigurationValidator(copilotBundleConfigurationProvider: bundleConfigurationProvider).validate()
        
        NetworkParameters.shared.setConfigurationProvider(bundleConfigurationProvider)
        
        let authenticationProviderContainer = AuthenticationProviderContainer()
        
        report = ReportAPI(isGDPRCompliant: bundleConfigurationProvider.isGdprCompliant ?? false)

        let sequentialExecutionHelper = MoyaSequentialExecutionHelper()
        
        let iaManager = InAppManager(reportApiAccess: report, sequentialExecutionHelper: sequentialExecutionHelper)
        inAppMessages = iaManager
        sessionNotifier.registerObserver(observer: iaManager)
        
        manage = Manage(authenticationProviderContainer: authenticationProviderContainer, reporter: report, configurationProvider: bundleConfigurationProvider,sessionObserver: sessionNotifier, sequentialExecutionHelper: sequentialExecutionHelper)
        
        
        let authenticationProvider: AuthenticationProvider
        
        if let authProvider = authenticationProviderContainer.authenticationProvider {
            authenticationProvider = authProvider
            iaManager.setAuthProvider(authProvider)
        } else {
            authenticationProvider = EmptyAuthenticationProvider()
            ZLogManagerWrapper.sharedInstance.logError(message: "Failed to create Copilot/External Authentication Provider")
        }
        
        let copilotDependencies = CopilotDependencies(authenticationProvider: authenticationProvider)
        
        
        KeyboardStateListener.shared.start()

        documentStorage = DoucmentStorageManager(authenticationProvider: authenticationProvider, sequentialExecutionHelper: sequentialExecutionHelper)
    }
    
    // MARK: - Public Setup
    
    /// Setup Copilot's analytics dependencies with the given providers. This needs to be called after the app is launched, prior to using Copilot services.
    public static func setup(analyticsProviders: [EventLogProvider], customPlistName: String? = nil) -> Copilot {
        if let customPlistName = customPlistName {
            BundleConfigurationProvider.plistName = customPlistName
        }

        analyticsProviders.forEach {
            AnalyticsEventsManager.sharedInstance.eventsProviderHandler.addEventLogProvider(newEventLogProvider: $0)
        }
        return instance
    }

    public func registerAppNavigationDelegate(_ appNavigationDelegate: AppNavigationDelegate?){
        inAppMessages.setAppNavigationDelegate(appNavigationDelegate)
    }

    public func copilotVersion() -> String {
        VersionResolver().copilotVersion
    }
}
