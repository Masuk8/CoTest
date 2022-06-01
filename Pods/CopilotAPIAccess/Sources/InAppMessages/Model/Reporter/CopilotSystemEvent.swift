//
// Created by Alex Gold on 12/10/2021.
// Copyright (c) 2021 Zemingo. All rights reserved.
//

import Foundation

class CopilotSystemEvent: AnalyticsEvent {

	private let subEventKey: String = "copilot_event_name"

	var eventOrigin: AnalyticsEventOrigin = .App
	var eventName: String
	var customParams: Dictionary<String, String> = [:]

	init(eventName: String, subEventName: String) {
		self.eventName = eventName
		customParams[subEventKey] = subEventName
	}
}
