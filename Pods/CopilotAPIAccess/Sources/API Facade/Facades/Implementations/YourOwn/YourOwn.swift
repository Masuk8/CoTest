//
//  YourOwn.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 20/05/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public class YourOwn: YourOwnAccess {
    
    public let auth: ExternalAuthAccess
    
    private var externalUserRepository: ExternalUserGeneralParametersRepository? = nil
        
    private let sessionLifeTimeProvider: SessionLifeTimeProvider
    private var currentUserId: String?
    private var reporter: ReportAPIAccess
    
    init(authenticationProviderContainer: AuthenticationProviderContainer, reporter: ReportAPIAccess, sessionObserver: SessionLifeTimeObserver) {
        auth = ExternalAuth(authenticationProviderContainer: authenticationProviderContainer)
        sessionLifeTimeProvider = SessionLifeTimeProvider()
        sessionLifeTimeProvider.add(observer: sessionObserver)
        self.reporter = reporter
        
        if let userId = PersistancyManager.getGeneralItem(withKey: PersistancyConstantKeys.customUserIdKey) as? String {
            if let externalAuth = auth as? ExternalAuthInternal {
                externalAuth.setUserId(userId)
            }
            
            let externalUserGeneralParamsRepo = ExternalUserGeneralParametersRepository()
            externalUserGeneralParamsRepo.userId = userId
            AnalyticsEventsManager.sharedInstance.sessionBasedAnalyticsRepository.addGeneralParamsForCurrentSession(generalParamsForSession: externalUserGeneralParamsRepo)
            AnalyticsEventsManager.sharedInstance.eventsDispatcher.setUserId(userId: userId)
            
            externalUserRepository = externalUserGeneralParamsRepo
            
            // default value when there is userId
            var actualConsent = true
            if let isCopilotAnalysisConsentApproved = PersistancyManager.getGeneralItem(withKey: PersistancyConstantKeys.customAnalysisConsentKey) as? Bool {
                actualConsent = isCopilotAnalysisConsentApproved
            } else {
                ZLogManagerWrapper.sharedInstance.logInfo(message: "Failed to get analysis consent.")
            }
            AnalyticsEventsManager.sharedInstance.updateConsent(with: actualConsent)
            
            currentUserId = userId
            sessionLifeTimeProvider.invoke { $0?.sessionStarted(userId) }
        } else {
            ZLogManagerWrapper.sharedInstance.logInfo(message: "Failed to get user Id.")
        }
    }
    
    public func sessionStarted(withUserId userId: String, isCopilotAnalysisConsentApproved: Bool) {
        if let currentUserId = currentUserId, currentUserId != userId {
            //End last session if replacing user
            sessionEnded()
        }
        let externalUserGeneralParamsRepo = ExternalUserGeneralParametersRepository()
        externalUserGeneralParamsRepo.userId = userId
        AnalyticsEventsManager.sharedInstance.sessionBasedAnalyticsRepository.addGeneralParamsForCurrentSession(generalParamsForSession: externalUserGeneralParamsRepo)
        AnalyticsEventsManager.sharedInstance.eventsDispatcher.setUserId(userId: userId)
        
        externalUserRepository = externalUserGeneralParamsRepo
        
        PersistancyManager.setGeneral(item: userId, key: PersistancyConstantKeys.customUserIdKey)
        PersistancyManager.setGeneral(item: isCopilotAnalysisConsentApproved, key: PersistancyConstantKeys.customAnalysisConsentKey)
        
        AnalyticsEventsManager.sharedInstance.updateConsent(with: isCopilotAnalysisConsentApproved)
        
        if let externalAuth = auth as? ExternalAuthInternal {
            externalAuth.setUserId(userId)
        }
        currentUserId = userId
        sessionLifeTimeProvider.invoke { $0?.sessionStarted(userId) }
        reporter.log(event: SessionStartedAnalyticsEvent())
    }
    
    public func sessionEnded() {
        // Notify the analytics component]
        (reporter as? ReportAPIAccessPrivate)?.log(event: SessionEndedAnalyticsEvent()) {
            AnalyticsEventsManager.sharedInstance.sessionBasedAnalyticsRepository.sessionEnded()
            AnalyticsEventsManager.sharedInstance.eventsDispatcher.setUserId(userId: nil)
            self.externalUserRepository?.userId = nil
        }

        PersistancyManager.deleteGeneralItem(withKey: PersistancyConstantKeys.customUserIdKey)
        externalUserRepository = nil
        
        PersistancyManager.deleteGeneralItem(withKey: PersistancyConstantKeys.customAnalysisConsentKey)
        AnalyticsEventsManager.sharedInstance.updateConsent(with: true)
        
        if let externalAuthAPI = auth as? ExternalAuth {
            externalAuthAPI.resetTokenProvider()
        }
        currentUserId = nil
        sessionLifeTimeProvider.invoke { $0?.sessionEnded() }
    }
    
    public func setCopilotAnalysisConsent(isConsentApproved: Bool) {
        PersistancyManager.setGeneral(item: isConsentApproved, key: PersistancyConstantKeys.customAnalysisConsentKey)
        AnalyticsEventsManager.sharedInstance.updateConsent(with: isConsentApproved)
    }
}
