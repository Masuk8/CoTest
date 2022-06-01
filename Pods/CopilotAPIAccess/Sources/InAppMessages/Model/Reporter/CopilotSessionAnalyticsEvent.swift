//
// Created by Alex Gold on 14/10/2021.
// Copyright (c) 2021 Zemingo. All rights reserved.
//

import Foundation

class CopilotSessionAnalyticsEvent: CopilotSystemEvent {

	init(subEvent: SessionSubEvent) {
		super.init(eventName: "cplt_system", subEventName: subEvent.rawValue)
	}
}

class SessionStartedAnalyticsEvent: CopilotSessionAnalyticsEvent {
	init() {
		super.init(subEvent: .sessionStarted)
	}
}

class SessionEndedAnalyticsEvent: CopilotSessionAnalyticsEvent {
	init() {
		super.init(subEvent: .sessionEnded)
	}
}