//
//  HtmlPopupDialogViewController.swift
//  CopilotAPIAccess
//
//  Created by Elad on 05/03/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation
import WebKit

class HtmlDialogViewController: DialogViewControllerBase {

    var dialogView: HtmlDialogView?

    var htmlView: HtmlDialogView {
       view as! HtmlDialogView // swif\tlint:disable:this force_cast
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dialogView = HtmlDialogView(frame: .zero)
        dialogView?.dismissDelegate = dismissDelegate
        view = dialogView
    }
}

extension HtmlDialogViewController {
    // MARK: Content
    
    var webContent: String? {
        get { return htmlView.webContent }
        set { htmlView.webContent = newValue }
    }
}
