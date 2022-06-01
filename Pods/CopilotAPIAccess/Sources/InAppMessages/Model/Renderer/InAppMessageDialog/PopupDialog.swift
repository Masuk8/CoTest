//
//  PopupDialog.swift
//  CopilotAPIAccess
//
//  Created by Elad on 19/02/2020.
//  Copyright © 2020 Elad. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import CopilotLogger
import StoreKit
import MessageUI
import WebKit

enum InAppMessageType {
    case simple
    case html
    case nps
}

protocol ActionPerformer {
    func performAction(_ actionType: CtaActionType, completion: (() -> ())?)
}

public protocol DismissDelegate: AnyObject {
    func dismissPopup()
}


/// Creates a Popup dialog similar to UIAlertController
class PopupDialog: UIViewController, DismissDelegate {

    // MARK: Private / Internal

    /// First init flag
    fileprivate var initialized = false

    /// StatusBar display related
    fileprivate let hideStatusBar: Bool
    fileprivate var statusBarShouldBeHidden: Bool = false

    /// Width for iPad displays
    fileprivate let preferredWidth: CGFloat

    /// The inAppMessage type
    fileprivate let inAppMessageType: InAppMessageType

    /// The completion handler
    fileprivate var completion: (() -> Void)?

    /// The custom transition presentation manager
    fileprivate var presentationManager: PresentationManager!

    /// Returns the controllers view
    var popupContainerView: PopupDialogContainerView {
        return view as! PopupDialogContainerView // swiftlint:disable:this force_cast
    }


    /// The set of buttons
    fileprivate var buttons = [InAppButton]()

    ///The set of htmlButtons
    var htmlButtons = [CtaHtmlType]()

    var htmlButtonCompletion: (() -> ())?

    ///html cta press indicator
    var htmlCtaPressed: (() -> Void)?
    /// The content view of the popup dialog
    var viewController: UIViewController

    //safari view controller
    private var safariVC: SFSafariViewController!

    //In-App messages delegate
    private let appNavigationDelegate: AppNavigationDelegate?

    //nps completion
    var npsSurveyCompletion: ((String?) -> Void)?

    //for presenting the popup on new window
    private lazy var window: UIWindow = {
        let window = createWindow()
        let root = UIViewController()
        root.view.backgroundColor = .clear
        window.rootViewController = root
        return window
    }()

    private func createWindow() -> UIWindow {
        var window: UIWindow
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .first
            if let windowScene = windowScene as? UIWindowScene {
                window = UIWindow(windowScene: windowScene)
            } else {
                window = UIWindow(frame: UIScreen.main.bounds)
            }
        } else {
            window =  UIWindow(frame: UIScreen.main.bounds)
        }
        window.windowLevel = UIWindow.Level.statusBar + 1
        return window
    }

    // MARK: - Initializers

    /*!
     Creates a standard popup dialog with title, message and image field

     - parameter title:            The dialog title
     - parameter message:          The dialog message
     - parameter imageUrl:         The dialog imageUrl
     - parameter buttonAlignment:  The dialog button alignment
     - parameter transitionStyle:  The dialog transition style
     - parameter preferredWidth:   The preferred width for iPad screens
     - parameter hideStatusBar:    Whether to hide the status bar on PopupDialog presentation
     - parameter completion:       Completion block invoked when dialog was dismissed

     - returns: Popup dialog default style
     */

    convenience init(
            title: String?,
            message: String?,
            bgColor: String?,
            titleColor: String?,
            bodyColor: String?,
            imageUrl: String? = nil,
            buttonAlignment: NSLayoutConstraint.Axis = .vertical,
            transitionStyle: PopupDialogTransitionStyle = .bounceUp,
            preferredWidth: CGFloat = 340,
            hideStatusBar: Bool = false,
            isHtmlPopup: Bool = false,
            inAppDelegate: AppNavigationDelegate?,
            dismissDelegate: DismissDelegate?,
            completion: (() -> Void)? = nil) {

        // Create and configure the standard popup dialog view
        let viewController = SimpleInappDialogViewController(dismissDelegate: dismissDelegate)
        viewController.titleText = title
        viewController.messageText = message
        if let bgColor = bgColor {
            viewController.messageBackgroundColor = UIColor(hexString: bgColor)
        }
        if let titleColor = titleColor {
            viewController.titleColor = UIColor(hexString: titleColor)
            viewController.messageColor = UIColor(hexString: titleColor)
        }

        if let imageUrl = imageUrl {
            if !imageUrl.isEmpty {
                viewController.image = UIImage()
                ImageCacher(dataManager: DataFileManager()).loadImage(forUrl: imageUrl) { result in
                    switch result {
                    case .Success(let image):
                        viewController.image = image
                    case .Failure:
                        viewController.image = nil
                        viewController.standardView.imageView.isHidden = true
                    }
                }
            }
        }

        // Call designated initializer
        self.init(viewController: viewController,
                buttonAlignment: buttonAlignment,
                transitionStyle: transitionStyle,
                preferredWidth: preferredWidth,
                hideStatusBar: hideStatusBar,
                appNavigationDelegate: inAppDelegate,
                inAppMessageType: .simple,
                completion: completion)
    }

    //MARK: for html popup view
    convenience init(htmlContent: String,
                     hideStatusBar: Bool = false,
                     inAppDelegate: AppNavigationDelegate?,
                     dismissDelegate: DismissDelegate?,
                     completion: (() -> Void)? = nil) {

        let viewController = HtmlDialogViewController(dismissDelegate: dismissDelegate)
        viewController.webContent = htmlContent
        //Call designated initializer
        self.init(viewController: viewController,
                hideStatusBar: hideStatusBar,
                appNavigationDelegate: inAppDelegate,
                inAppMessageType: .html,
                completion: completion)
        viewController.htmlView.webview.navigationDelegate = self
    }

    //MARK: for NPS popup view
    convenience init(labelQuestionText: String,
                     ctaBackgroundColor: String,
                     ctaTextColor: String,
                     inAppDelegate: AppNavigationDelegate?,
                     bgColor: String,
                     textColorHex: String,
                     labelNotLikely: String,
                     labelExtremelyLikely: String,
                     labelAskMeAnotherTime: String,
                     labelDone: String,
                     labelThankYou: String,
                     dismissDelegate: DismissDelegate?,
                     imageUrl: String? = nil,
                     completion: (() -> Void)? = nil) {

        let viewController = NpsDialogViewController(dismissDelegate: dismissDelegate)
        viewController.labelQuestionText = labelQuestionText
        viewController.ctaBackgroundColor = UIColor(hexString: ctaBackgroundColor)
        viewController.ctaTextColor = UIColor(hexString: ctaTextColor)
        viewController.bgColor = UIColor(hexString: bgColor)
        viewController.textColorHex = UIColor(hexString: textColorHex)
        viewController.labelNotLikely = labelNotLikely
        viewController.labelExtremelyLikely = labelExtremelyLikely
        viewController.labelAskMeAnotherTime = labelAskMeAnotherTime
        viewController.labelDone = labelDone
        viewController.labelThankYou = labelThankYou
        viewController.image = UIImage()

        if let imageUrl = imageUrl {
			if !imageUrl.isEmpty {
                viewController.image = UIImage()
                ImageCacher(dataManager: DataFileManager()).loadImage(forUrl: imageUrl) { result in
                    switch result {
                    case .Success(let image):
                        viewController.image = image
                    case .Failure:
                        viewController.image = nil
                        viewController.dialogView.imageView.isHidden = true
                    }
                }
            }
        }

        //Call designated initializer
        self.init(viewController: viewController,
                  appNavigationDelegate: inAppDelegate,
                  inAppMessageType: .nps,
                  completion: completion)

        viewController.completion = { [weak self] (str) in
            self?.npsSurveyCompletion?(str)
            self?.dismiss()
        }
    }

    /*!
     Creates a popup dialog containing a custom view

     - parameter viewController:   A custom view controller to be displayed
     - parameter buttonAlignment:  The dialog button alignment
     - parameter transitionStyle:  The dialog transition style
     - parameter preferredWidth:   The preferred width for iPad screens
     - parameter hideStatusBar:    Whether to hide the status bar on PopupDialog presentation
     - parameter completion:       Completion block invoked when dialog was dismissed

     - returns: Popup dialog with a custom view controller
     */
    init(
            viewController: UIViewController,
            buttonAlignment: NSLayoutConstraint.Axis = .vertical,
            transitionStyle: PopupDialogTransitionStyle = .bounceUp,
            preferredWidth: CGFloat = 340,
            hideStatusBar: Bool = false,
            appNavigationDelegate: AppNavigationDelegate?,
            inAppMessageType: InAppMessageType,
            completion: (() -> Void)? = nil) {

        self.viewController = viewController
        self.preferredWidth = preferredWidth
        self.hideStatusBar = hideStatusBar
        self.completion = completion
        self.appNavigationDelegate = appNavigationDelegate
        self.inAppMessageType = inAppMessageType

        super.init(nibName: nil, bundle: nil)

        // Init the presentation manager
        presentationManager = PresentationManager(transitionStyle: transitionStyle)


        // Define presentation styles
        transitioningDelegate = presentationManager
        modalPresentationStyle = .custom

        // StatusBar setup
        modalPresentationCapturesStatusBarAppearance = true

        // Add our custom view to the container
        addChild(viewController)
        popupContainerView.mainStackView.insertArrangedSubview(viewController.view, at: 0)
        viewController.didMove(toParent: self)
    }

    // Init with coder not implemented
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View life cycle

    /// Replaces controller view with popup view
    override func loadView() {
        view = PopupDialogContainerView(frame: UIScreen.main.bounds, preferredWidth: preferredWidth, inAppMessageType: inAppMessageType)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard !initialized else { return }
        appendButtons()
        initialized = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        statusBarShouldBeHidden = hideStatusBar
        UIView.animate(withDuration: 0.15) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    deinit {
        completion?()
        completion = nil
    }

    // MARK: - Dismissal related

    /*!
     Dismisses the popup dialog
     */
    func dismiss(_ completion: (() -> Void)? = nil) {
        self.dismiss(animated: true) {
            self.window.dismiss()
            completion?()
        }
    }

    // MARK: - Button related

    /*!
     Appends the buttons added to the popup dialog
     to the placeholder stack view
     */
    fileprivate func appendButtons() {

        // Add action to buttons if the viewController is kind of PopupDialogViewController
        if let viewController = viewController as? SimpleInappDialogViewController {
            if buttons.isEmpty {
                viewController.buttons = []
                return
            }
            viewController.buttons = buttons
            buttons.forEach {
                $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            }
        }
    }

    /*!
     Adds a single InAppButton to the Popup dialog
     - parameter button: A InAppButton instance
     */
    func addButton(_ button: InAppButton) {
        buttons.append(button)
    }

    /*!
     Adds an array of InAppButtons to the Popup dialog
     - parameter buttons: A list of InAppButton instances
     */
    func addButtons(_ buttons: [InAppButton]) {
        self.buttons += buttons
    }

    /// Calls the action closure of the button instance tapped
    @objc fileprivate func buttonTapped(_ button: InAppButton) {
        button.buttonAction?()
    }


    // MARK: - StatusBar display related

    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    //MARK: - Show popupDialog on window

    func show(animated: Bool = true, completion: (() -> Void)? = nil)  {
        if let rootViewController = window.rootViewController {
            window.makeKeyAndVisible()
            rootViewController.present(self, animated: animated, completion: completion)
        }
    }
    //MARK: - transition

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

    func dismissPopup() {
        self.dismiss()
    }
}

// MARK: - View proxy values

extension PopupDialog {

    /// The transition style
    var transitionStyle: PopupDialogTransitionStyle {
        get { return presentationManager.transitionStyle }
        set { presentationManager.transitionStyle = newValue }
    }
}

extension PopupDialog: ActionPerformer {

    func performAction(_ actionType: CtaActionType, completion: (() -> ())?) {
        popupContainerView.isHidden = true
        switch actionType {
        case .appStoreRate:
            rateOnAppstore()
        case .webNavigation(let url):
            if let url = URL(string: url) {
                openSafariVC(with: url, completion: completion)
            } else {
                ZLogManagerWrapper.sharedInstance.logError(message: "cta url is invalid")
            }
        case .externalLink(let identifier, let iosLink, let webLink):
            openExternalLink(identifier: identifier, iosLink: iosLink, webLink: webLink)
        case .call(let phoneNumber):
            callTo(number: phoneNumber)
        case .sendEmail(let mailTo, let subject, let body):
            sendEmail(to: mailTo, subject: subject, body: body)
        case .share(let shareText):
            share(text: shareText ?? "")
        case .none:
            self.dismiss()
        case .appNavigation(let appNavigationCommand):
            performAppNavigationAction(appNavigationCommand)
        }
        completion?()
    }

    private func share(text: String?) {
        let items = [text]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            // User completed activity
            self.dismiss()
        }
        present(activityController, animated: true)
    }

    private func openSafariVC(with url: URL, completion: (() -> ())?) {
        safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: {
            completion?()
        })
    }

    private func rateOnAppstore() {
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
            self.dismiss()
        }
    }

    private func callTo(number: String) {
        guard let numberToCall = URL(string: "tel://" + number) else { return }
        UIApplication.shared.open(numberToCall)
        self.dismiss()
    }

    private func sendEmail(to: String?, subject: String?, body: String?) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            if let sendTo = to {
                mail.setToRecipients([sendTo])
            }
            if let messageBody = body {
                mail.setMessageBody(messageBody, isHTML: false)
            }
            mail.setSubject(subject ?? "")

            present(mail, animated: true)
        } else {
            let mailtoString = formatMailtoString(to: to, subject: subject, body: body)
            if let mailtoUrl = URL(string: mailtoString) {
                if UIApplication.shared.canOpenURL(mailtoUrl) {
                    UIApplication.shared.open(mailtoUrl, options: [:], completionHandler: nil)
                }

            } else {
                ZLogManagerWrapper.sharedInstance.logError(message: "can't send email")
            }
            dismiss()
        }
    }

    private func formatMailtoString(to: String?, subject: String?, body: String?) -> String {
        "mailto:\(to ?? "")?subject=\(subject ?? "")&body=\(body ?? "")"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }

    private func performAppNavigationAction(_ appNavigationCommand: String) {
        dismiss()
        appNavigationDelegate?.handleAppNavigation(appNavigationCommand)
    }

    private func openExternalLink(identifier: String?, iosLink: String?, webLink: String? ) {
        if let identifier = identifier, let scheme = URL(string: identifier), UIApplication.shared.canOpenURL(scheme) {
            if let url = iosLink, let validUrl = URL(string: url){
                UIApplication.shared.open(validUrl) { [weak self](_) in
                    self?.dismiss()
                }
            }
        } else if let webLink = webLink, let validUrl = URL(string: webLink), UIApplication.shared.canOpenURL(validUrl) {
            UIApplication.shared.open(validUrl){
                [weak self](_) in
                self?.dismiss()
            }
        } else {
            let alert = UIAlertController(title: nil, message: "Can't find supporting application", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { [weak self] _ in
                self?.dismiss()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - MFMailComposeViewControllerDelegate
extension PopupDialog: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss()
    }
}

//MARK: - SFSafariViewControllerDelegate
extension PopupDialog: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss()
    }
}

extension PopupDialog: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let navigationActionUrl = navigationAction.request.url, navigationActionUrl.absoluteString.contains("cplt://") {
            htmlCtaPressed?()
            let actionString = navigationActionUrl.absoluteString.replacingOccurrences(of: "cplt://", with: "")
            performHtmlAction(with: actionString)
        }
        decisionHandler(.allow)
    }

    private func performHtmlAction(with urlActionString: String) {
        htmlButtons.forEach { [weak self] in
            if $0.redirectId == urlActionString {
                performAction($0.action) {
                    self?.htmlButtonCompletion?()
                }
            }
        }
    }
}
