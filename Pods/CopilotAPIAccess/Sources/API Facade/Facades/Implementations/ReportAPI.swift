//
//  ReportAPI.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 20/11/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public class ReportAPI: ReportAPIAccess, ReportAPIAccessPrivate {

    init(isGDPRCompliant: Bool) {
        AnalyticsEventsManager.sharedInstance.shouldLogEvents = !isGDPRCompliant
    }
    
    // MARK: - ReportAPIAccess
    
    public func log(event: AnalyticsEvent) {
        AnalyticsEventsManager.sharedInstance.eventsDispatcher.dispatcherLogCustomEvent(event: event, completion: nil)
    }

    func log(event: AnalyticsEvent, completion: (() -> ())?) {
        AnalyticsEventsManager.sharedInstance.eventsDispatcher.dispatcherLogCustomEvent(event: event, completion: completion)
    }
}
