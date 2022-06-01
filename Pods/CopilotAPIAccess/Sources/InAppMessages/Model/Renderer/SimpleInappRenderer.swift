//
//  SimpleRenderer.swift
//  CopilotAPIAccess
//
//  Created by Elad on 10/02/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

class SimpleInappRenderer: BaseRenderer<SimpleInappPresentationModel>, Renderer, DismissDelegate {

    private weak var popupDialog: PopupDialog?
    private var reporter: InAppReporter?
    private var iamReport: InAppMessageReport?
    private var messageId: String?

    func render(reporter: InAppReporter, iamReport: InAppMessageReport, messageId: String, delegate: AppNavigationDelegate?) {
        self.reporter = reporter
        self.iamReport = iamReport
        self.messageId = messageId
        showAlert(reporter: reporter, iamReport: iamReport, delegate: delegate)
    }
    
    private func showAlert(reporter: InAppReporter, iamReport: InAppMessageReport, delegate: AppNavigationDelegate?) {

        let bodyText = presentationModel.bodyText ?? ""

//        // Create the in app message popup

        var buttonAlignment: NSLayoutConstraint.Axis

        if UIDevice.current.orientation.isPortrait && presentationModel.ctas.count == 3 {
            buttonAlignment = .vertical
        } else {
            buttonAlignment = .horizontal
        }

        popupDialog = PopupDialog(
                title: presentationModel.title,
                message: bodyText,
                bgColor: presentationModel.bgColor,
                titleColor: presentationModel.titleColor,
                bodyColor: presentationModel.bodyColor,
                imageUrl: presentationModel.imageUrl,
                buttonAlignment: buttonAlignment,
                preferredWidth: 330,
                inAppDelegate: delegate,
                dismissDelegate: self)

        presentationModel.ctas.forEach { [weak self] (ctaType) in
            if let cta = ctaType as? CtaButtonType {
                let button = InAppButton(title: cta.text, textColor: UIColor(hexString: cta.textColorHex), bdColor: UIColor(hexString: cta.backgroundColorHex)) {
                    //cta clicked
                    reporter.reportMessageCtaClicked(generalParameters: iamReport.parameters, ctaReportParam: cta.report)
                    self?.popupDialog?.performAction(cta.action) {
                        ZLogManagerWrapper.sharedInstance.logInfo(message: "cta perform action completed")
                    }
                }
                self?.popupDialog?.addButton(button)
            } else {
                ZLogManagerWrapper.sharedInstance.logError(message: "can't cast to ctaButtonType")
            }
        }
        popupDialog?.show(animated: false) {
            ZLogManagerWrapper.sharedInstance.logInfo(message: "In App Message is presented successfully")
        }
    }
    
    func dismissPopup() {
		reporter?.reportInAppDismissed(generalParameters: iamReport?.parameters ?? [:])
        if let messageId = messageId { reporter?.clearPreviousBlocked(messageId: messageId) }
        popupDialog?.dismissPopup()
    }
}
