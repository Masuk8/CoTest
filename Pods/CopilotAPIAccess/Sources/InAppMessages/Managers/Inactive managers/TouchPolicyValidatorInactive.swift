//
//  TouchPolicyValidatorInactive.swift
//  CopilotAPIAccess
//
//  Created by Elad on 13/02/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

class TouchPolicyValidatorInactive: TouchPolicyValidator {
	public static let shared = TouchPolicyValidatorInactive()

	private init() { }

	func canInteractWithUserAndUpdateInteractedIfNeeded(shouldIgnoreTouchpoint ignoreTouchpoint: Bool) -> Bool {
		false
	}

	func resolveUpdatedConfiguration(newTouchPointPolicyValidator: TouchPolicyValidator) -> TouchPolicyValidator {
		newTouchPointPolicyValidator
	}
}
