//
// Created by Alex Gold on 23/03/2022.
// Copyright (c) 2022 Zemingo. All rights reserved.
//

import Foundation

class DeleteUserRequestExecuter: RequestExecuter<Void, DeleteUserError> {
	private let dependencies: HasUserServiceInteraction

	init(dependencies: HasUserServiceInteraction) {
		self.dependencies = dependencies
		super.init()
	}

	override func execute(_ closure: @escaping (Response<Void, DeleteUserError>) -> Void) {
		dependencies.userServiceInteraction.deleteMe(deleteUserClosure: closure)
	}
}