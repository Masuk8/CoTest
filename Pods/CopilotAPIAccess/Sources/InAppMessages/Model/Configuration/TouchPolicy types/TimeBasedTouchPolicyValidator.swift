//
//  TimeBasedTouchPolicy.swift
//  CopilotAPIAccess
//
//  Created by Elad on 27/01/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

class TimeBasedTouchPolicyValidator: TouchPolicyValidator {

	//MARK: - Consts
	private struct Keys {
		static let minSecondsBetweenInteractions = "minSecondsBetweenInteractions"
	}

	//MARK: - Properties
	private var minSecondsBetweenInteractions: TimeInterval

	private var previousInteractionInSeconds: TimeInterval = 0

	private let serialQueue = DispatchQueue(label: "timeBasedTouchPolicyQueue")

	// MARK: - Init
	init?(withDictionary dictionary: [String: Any]) {
		guard let minSecondsBetweenInteractions = dictionary[Keys.minSecondsBetweenInteractions] as? TimeInterval else { return nil }
		self.minSecondsBetweenInteractions = minSecondsBetweenInteractions
	}

	init(minSecondsBetweenInteractions: TimeInterval) {
		self.minSecondsBetweenInteractions = minSecondsBetweenInteractions
	}

	//MARK: - TouchPolicyValidator implementation
	func canInteractWithUserAndUpdateInteractedIfNeeded(shouldIgnoreTouchpoint ignoreTouchpoint: Bool) -> Bool {
		serialQueue.sync {
			if ignoreTouchpoint {
				setInteracted()
				return true
			}

			let shouldInteract = nowInSeconds() - previousInteractionInSeconds >= minSecondsBetweenInteractions
			if shouldInteract { setInteracted() }
			return shouldInteract
		}
	}

    func resolveUpdatedConfiguration(newTouchPointPolicyValidator: TouchPolicyValidator) -> TouchPolicyValidator {
        guard let newTouchPointPolicy = newTouchPointPolicyValidator as? TimeBasedTouchPolicyValidator else {
            return newTouchPointPolicyValidator
        }
        minSecondsBetweenInteractions = newTouchPointPolicy.minSecondsBetweenInteractions
        return self
    }

	//MARK: - Private
	private func nowInSeconds() -> TimeInterval {
		return Date().timeIntervalSince1970
	}

	private func setInteracted() {
		previousInteractionInSeconds = nowInSeconds()
	}
}
