//
// Created by Alex Gold on 13/10/2021.
// Copyright (c) 2021 Zemingo. All rights reserved.
//

import Foundation

class DialogViewControllerBase: UIViewController {
	var dismissDelegate: DismissDelegate?

	init(dismissDelegate: DismissDelegate?) {
		super.init(nibName: nil, bundle: nil)
		self.dismissDelegate = dismissDelegate
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
