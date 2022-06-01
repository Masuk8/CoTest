//
// Created by Alex Gold on 14/10/2021.
// Copyright (c) 2021 Zemingo. All rights reserved.
//

import Foundation

class InAppAnalyticsEvent: CopilotSystemEvent {

	init(subEvent: InAppSubEvent, generalParams: [String: String]) {
		super.init(eventName: "cplt_in_app", subEventName: subEvent.rawValue)
		customParams.merge(generalParams) { (_, last) in last}
	}
}

class InAppCtaClickedAnalyticsEvent: InAppAnalyticsEvent {
	init(reportParam: String, generalParams: [String: String]) {
		super.init(subEvent: .clicked , generalParams: generalParams)
		customParams["cta"] = reportParam
	}
}

class InAppTriggeredAnalyticsEvent: InAppAnalyticsEvent {
	init(generalParameters: [String : String]) {
		super.init(subEvent: .triggered, generalParams: generalParameters)
	}
}

class InAppMessageDisplayedAnalyticsEvent: InAppAnalyticsEvent {
	init(generalParameters: [String : String]) {
		super.init(subEvent: .displayed, generalParams: generalParameters)
	}
}

class InAppDismissedAnalyticsEvent: InAppAnalyticsEvent {

	init(generalParams: [String: String]) {
		super.init(subEvent: .inAppDismissed, generalParams: generalParams)
		customParams["dismiss_type"] = "x_button_clicked"
	}
}

class InAppBlockedAnalyticsEvent: InAppAnalyticsEvent {
	init(reason: InAppBlockedReason, generalParams: [String: String]) {
		super.init(subEvent: .inAppBlocked, generalParams: generalParams)
		customParams["reason"] = reason.rawValue
	}
}

class SupportedActionsAnalyticsEvent: InAppAnalyticsEvent {

	public init(supportedAppNavigationCommand: String) {
		super.init(subEvent: .appNavigationSupportedAction, generalParams: [:])
		customParams["command_name"] = supportedAppNavigationCommand
	}
}