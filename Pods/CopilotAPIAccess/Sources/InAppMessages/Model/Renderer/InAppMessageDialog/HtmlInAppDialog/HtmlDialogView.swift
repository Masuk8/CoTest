//
//  HtmlDialogDefaultView.swift
//  CopilotAPIAccess
//
//  Created by Elad on 05/03/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation
import UIKit
import WebKit

/// The main view of the popup dialog
 class HtmlDialogView: UIView {

     var dismissDelegate : DismissDelegate?

    var webContent: String? {
        willSet {
            if let webContent = newValue {
                let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
                webview.loadHTMLString(headerString + webContent, baseURL: nil)
                }
        }
    }
     //MARK: Properties
    lazy var webview: WKWebView  = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

     lazy var dismissButton: UIView = {
         let image = UIImage(named: "clear", in: Bundle(for: Copilot.self), compatibleWith: nil) as UIImage?
         let button = UIButton(type: .custom) as UIButton
         button.backgroundColor = .none
         button.translatesAutoresizingMaskIntoConstraints = false
         button.setHeight(27)
         button.setWidth(27)
         button.setImage(image, for: .normal)
         button.contentHorizontalAlignment = .right
         button.contentVerticalAlignment = .top
         button.addTarget(self, action: #selector(dismissPressed), for: .touchUpInside)
         return button
     }()


    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(webview, dismissButton)

        webview.anchorToSuperview()
        dismissButton.anchorToSuperview(top:6, leading: nil, trailing: 6, bottom: nil )
    }

     @objc func dismissPressed(){
         dismissDelegate?.dismissPopup()
     }
}
