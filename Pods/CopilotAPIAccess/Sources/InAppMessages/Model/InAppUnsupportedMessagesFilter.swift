//
// Created by Michael Noy on 02/08/2021.
// Copyright (c) 2021 Zemingo. All rights reserved.
//

import Foundation

class InAppUnsupportedMessagesFilter {
    func filter(appNavigationHandler: AppNavigationDelegate?, messages: [InAppMessage]) -> [InAppMessage] {

        messages.filter { message in
            var ctas: [CtaType]
            if (message.presentation is SimpleInappPresentationModel) {
                let presentation = message.presentation as! SimpleInappPresentationModel
                ctas = presentation.ctas
            } else if (message.presentation is HtmlInappPresentationModel) {
                let presentation = message.presentation as! HtmlInappPresentationModel
                ctas = presentation.ctas
            } else {
                return true
            }

            return ctas.allSatisfy { cta in
                checkCtaSatisfy(cta: cta, appNavigationHandler: appNavigationHandler)
            }
        }
    }

    private func checkCtaSatisfy(cta: CtaType, appNavigationHandler: AppNavigationDelegate?) -> Bool {

        var ctaActionType: CtaActionType? = nil
        if (cta is CtaButtonType) {
            let ctaButtonType = cta as! CtaButtonType
            ctaActionType = ctaButtonType.action
        } else if (cta is CtaHtmlType) {
            let ctaHtmlType = cta as! CtaHtmlType
            ctaActionType = ctaHtmlType.action
        }

        switch ctaActionType {
        case .appNavigation(appNavigationCommand: let appNavigationCommand):
            if let appNavigationHandler = appNavigationHandler {
                return appNavigationHandler.getSupportedAppNavigationCommands().contains(appNavigationCommand)
            } else {
                return false
            }
        default:
            return true
        }
    }
}