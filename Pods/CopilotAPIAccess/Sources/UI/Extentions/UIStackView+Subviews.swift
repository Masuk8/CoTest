//
// Created by Alex Gold on 26/09/2021.
// Copyright (c) 2021 Zemingo. All rights reserved.
//

import UIKit

extension UIStackView {
	func addArrangedSubviews(_ views: UIView...) {
		for view in views {
			addArrangedSubview(view)
		}
	}
}
