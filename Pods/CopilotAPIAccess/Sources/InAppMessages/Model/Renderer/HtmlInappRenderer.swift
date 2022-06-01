//
//  HtmlRenderer.swift
//  CopilotAPIAccess
//
//  Created by Elad on 10/02/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

class HtmlInappRenderer: BaseRenderer<HtmlInappPresentationModel>, Renderer, DismissDelegate {

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
        
        popupDialog = PopupDialog(htmlContent: presentationModel.content,inAppDelegate: delegate, dismissDelegate: self)
        
        presentationModel.ctas.forEach {(cta) in
            popupDialog?.htmlButtons.append(cta)
            popupDialog?.htmlCtaPressed = {
                reporter.reportMessageCtaClicked(generalParameters: iamReport.parameters, ctaReportParam: cta.report)
                ZLogManagerWrapper.sharedInstance.logInfo(message: "html button pressed")
            }
            popupDialog?.htmlButtonCompletion = {
                ZLogManagerWrapper.sharedInstance.logInfo(message: "html button action completed")
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
