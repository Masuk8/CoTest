//
//  AnalyticsEventGroup.swift
//  AOTAuth
//
//  Created by Tom Milberg on 28/05/2018.
//  Copyright © 2018 Falcore. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Providing AnalyticsEventGroup is not required anymore. Events will be disptched to all providers")
public enum AnalyticsEventGroup {
    case All
    case Engagement
    case Main
    case DevSupport
}
