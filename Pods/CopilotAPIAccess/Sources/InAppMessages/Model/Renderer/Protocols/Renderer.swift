//
//  Renderer.swift
//  CopilotAPIAccess
//
//  Created by Elad on 10/02/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

protocol Renderer {
	func render(reporter: InAppReporter, iamReport: InAppMessageReport, messageId: String, delegate: AppNavigationDelegate?)
	func verifyConditions() -> Bool
}

extension Renderer {

	func verifyConditions() -> Bool {
		var areConditionsVerified = false
		if Thread.isMainThread {
			areConditionsVerified = checkAllConditions()
		} else {
			DispatchQueue.main.sync {
				areConditionsVerified = checkAllConditions()
			}
		}
		return areConditionsVerified
	}

	private func checkAllConditions() -> Bool {
		!checkPopupDialogShowing() && checkIfApplicationStateIsActive() && !KeyboardStateListener.shared.isVisible
	}
	
	//MARK: - private
	private func checkPopupDialogShowing() -> Bool {
		let dialogController = UIApplication.shared.windows.first { window in
			let controller = window.visibleViewController()
			return controller is PopupDialog || controller is UIAlertController || controller is UIActivityViewController
		}
		return dialogController != nil
	}

	private func checkIfApplicationStateIsActive() -> Bool {
		var returnValue = false
		switch UIApplication.shared.applicationState {
		case .background, .inactive:
			returnValue = false
		case .active:
			returnValue = true
		default:
			break
		}
		return returnValue
	}
}
