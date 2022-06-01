//
// Created by Alex Gold on 24/03/2022.
// Copyright (c) 2022 Zemingo. All rights reserved.
//

import Foundation

public enum DeleteUserError: CopilotError {
	static func generalError(message: String) -> Self {
		return .generalError(debugMessage: message)
	}

	case requiresRelogin(debugMessage: String)
	case generalError(debugMessage: String)
	case connectivityError(debugMessage: String)
}

public class DeleteUserErrorResolver : ErrorResolver {
	public typealias T = DeleteUserError

	public func fromRequiresReloginError(debugMessage: String) -> DeleteUserError {
		return .requiresRelogin(debugMessage: debugMessage)
	}

	public func fromInvalidParametersError(debugMessage: String) -> DeleteUserError {
		return .generalError(debugMessage: "Unexpected invalid parameters \(debugMessage)")
	}

	public func fromGeneralError(debugMessage: String) -> DeleteUserError {
		return .generalError(debugMessage: debugMessage)
	}

	public func fromConnectivityError(debugMessage: String) -> DeleteUserError {
		return .connectivityError(debugMessage:debugMessage)
	}

	public func fromTypeSpecificError(_ statusCode: Int, _ reason: String, _ message: String) -> DeleteUserError? {
		return nil
	}
}