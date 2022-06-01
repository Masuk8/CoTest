//
//  CustomAnalyticsEvent.swift
//  CopilotAPIAccess
//
//  Created by Alex Gold on 30/09/2021.
//  Copyright © 2021 Zemingo. All rights reserved.
//

import Foundation

public class CustomAnalyticsEvent: AnalyticsEvent {
	public var eventName: String
	public var customParams: Dictionary<String, String>
	public var eventOrigin: AnalyticsEventOrigin

	public init(eventName: String, customParams: [String: String] = [:]) {
		eventOrigin = AnalyticsEventOrigin.App
		self.eventName = eventName
		self.customParams = customParams
	}
}
