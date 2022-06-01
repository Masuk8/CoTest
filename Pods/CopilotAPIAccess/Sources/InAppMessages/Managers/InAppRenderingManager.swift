//
//  InAppRenderingManager.swift
//  CopilotAPIAccess
//
//  Created by Elad on 10/02/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

class InAppRenderingManager: InAppRenderer {

    func canDisplay(inAppMessage: InAppMessage) -> Bool {
        inAppMessage.presentation.renderer.verifyConditions()
    }

    func render(inAppMessage: InAppMessage, reporter: InAppReporter, delegate: AppNavigationDelegate?) {
        DispatchQueue.main.async {
            inAppMessage.presentation.renderer.render(reporter: reporter, iamReport: inAppMessage.report, messageId: inAppMessage.id, delegate: delegate)
        }
    }

}



