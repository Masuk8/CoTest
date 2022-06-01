//
// Created by Alex Gold on 12/10/2021.
// Copyright (c) 2021 Zemingo. All rights reserved.
//

import Foundation

public enum InAppSubEvent: String {
	case triggered = "in_app_triggered"
	case displayed = "in_app_displayed"
	case clicked = "in_app_clicked"
	case inAppDismissed = "in_app_dismissed"
	case inAppBlocked = "in_app_blocked"
	case appNavigationSupportedAction = "app_navigation_supported_action"
}

public enum InAppBlockedReason: String {
	case touchPointPolicy = "touch_point_policy"
	case appConditions = "app_conditions"
	case inappDeactivated = "inapp_deactivated"
}

public enum SessionSubEvent: String {
	case sessionStarted = "sdk_session_started"
	case sessionEnded = "sdk_session_ended"
}