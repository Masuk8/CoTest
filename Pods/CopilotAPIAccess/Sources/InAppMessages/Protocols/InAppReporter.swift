//
//  InAppReporter.swift
//  CopilotAPIAccess
//
//  Created by Elad on 12/02/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

protocol InAppReporter {
    func reportMessageTriggered(generalParameters : [String : String])
    func reportMessageDisplayed(generalParameters : [String : String])
    func reportMessageCtaClicked(generalParameters : [String : String], ctaReportParam: String?)
    func reportInAppDismissed(generalParameters: [String: String])
    func reportInAppBlocked(reason: InAppBlockedReason, messageId: String, generalParameters: [String: String])
    func clearPreviousBlocked(messageId: String)
    func clearAllBlocked()
}
