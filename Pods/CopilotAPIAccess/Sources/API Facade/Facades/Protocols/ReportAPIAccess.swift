//
//  ReportAPIAccess.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 19/11/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public protocol ReportAPIAccess: AnyObject {

    /// Log an app analytics event.
    func log(event: AnalyticsEvent)
}

internal protocol ReportAPIAccessPrivate: ReportAPIAccess {
	func log(event: AnalyticsEvent, completion: (() -> ())?)
}
