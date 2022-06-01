//
// Created by Alex Gold on 24/03/2022.
// Copyright (c) 2022 Zemingo. All rights reserved.
//

import Foundation

class DeleteUserRequestBuilder: RequestBuilder<Void, DeleteUserError> {
	private let dependencies: HasUserServiceInteraction

	init(dependencies: HasUserServiceInteraction) {
		self.dependencies = dependencies
		super.init()
	}

	override func build() -> RequestExecuter<Void, DeleteUserError> {
		DeleteUserRequestExecuter(dependencies: dependencies)
	}
}