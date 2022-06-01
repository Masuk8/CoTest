//
//  NpsInappRenderer.swift
//  CopilotAPIAccess
//
//  Created by Elad on 13/05/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

class NpsInappRenderer: BaseRenderer<NpsInappPresentationModel>, Renderer, DismissDelegate {

    private weak var popupDialog: PopupDialog?
    private var reporter: InAppReporter?
    private var parameters: [String : String]?
    private var iamReport: InAppMessageReport?
    private var messageId: String?

    func render(reporter: InAppReporter, iamReport: InAppMessageReport, messageId: String, delegate: AppNavigationDelegate?) {
        self.reporter = reporter
        self.iamReport = iamReport
        self.messageId = messageId
        showAlert(reporter: reporter, iamReport: iamReport, delegate: delegate)
    }
    
    private func showAlert(reporter: InAppReporter, iamReport: InAppMessageReport, delegate: AppNavigationDelegate?) {

        popupDialog = PopupDialog(labelQuestionText: self.presentationModel.labelQuestionText,
                ctaBackgroundColor: presentationModel.ctaBackgroundColorHex,
                ctaTextColor: presentationModel.ctaTextColorHex,
                inAppDelegate: delegate,
                bgColor: presentationModel.backgroundColorHex,
                textColorHex: presentationModel.textColorHex,
                labelNotLikely: presentationModel.labelNotLikely,
                labelExtremelyLikely: presentationModel.labelExtremelyLikely,
                labelAskMeAnotherTime: presentationModel.labelAskMeAnotherTime,
                labelDone: presentationModel.labelDone,
                labelThankYou: presentationModel.labelThankYou,
                dismissDelegate: self,
                imageUrl: presentationModel.imageUrl) {
            ZLogManagerWrapper.sharedInstance.logInfo(message: "nps message dismissed")
        }

        popupDialog?.npsSurveyCompletion = { (ctaNumber: String?) in
            if let ctaNumber = ctaNumber {
                reporter.reportMessageCtaClicked(generalParameters: iamReport.parameters, ctaReportParam: "nps_answer=\(ctaNumber)")
                ZLogManagerWrapper.sharedInstance.logInfo(message: "NPS survey - user choose \(ctaNumber)")
            } else {
                ZLogManagerWrapper.sharedInstance.logInfo(message: "user dismissed the NPS survey message")
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
