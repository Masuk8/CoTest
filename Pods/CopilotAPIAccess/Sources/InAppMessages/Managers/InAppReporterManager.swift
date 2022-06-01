//
//  InAppReporterManager.swift
//  CopilotAPIAccess
//
//  Created by Elad on 12/02/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

class InAppReporterManager: InAppReporter {
    private var previousBlockedList = [String: [String: String]]()

    //MARK: - Properties
    typealias Dependencies = HasReporter
    private var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func reportMessageTriggered(generalParameters: [String : String]) {
        dependencies.reporter.log(event: InAppTriggeredAnalyticsEvent(generalParameters: generalParameters))
    }
    
    func reportMessageDisplayed(generalParameters: [String : String]) {
        dependencies.reporter.log(event: InAppMessageDisplayedAnalyticsEvent(generalParameters: generalParameters))
    }
    
    func reportMessageCtaClicked(generalParameters: [String : String], ctaReportParam: String?) {
        dependencies.reporter.log(event: InAppCtaClickedAnalyticsEvent(reportParam: ctaReportParam ?? "", generalParams: generalParameters))
    }

    func reportInAppDismissed(generalParameters: [String: String]) {
        dependencies.reporter.log(event: InAppDismissedAnalyticsEvent(generalParams: generalParameters))
    }

    func reportInAppBlocked(reason: InAppBlockedReason, messageId: String, generalParameters: [String: String]) {

        if previousBlockedList[messageId] == nil {
            previousBlockedList[messageId] = [String: String]()
        }

        if previousBlockedList[messageId]!.contains(where: { $0.key == reason.rawValue }) {
            return
        }

        print("Blocked - added another for messageId: \(messageId)")
        previousBlockedList[messageId] = [reason.rawValue: reason.rawValue]
        dependencies.reporter.log(event: InAppBlockedAnalyticsEvent(reason: reason, generalParams: generalParameters))
    }

    func clearPreviousBlocked(messageId: String) {
        previousBlockedList[messageId] = [String: String]()
    }

    func clearAllBlocked() {
        previousBlockedList.removeAll()
    }
}
