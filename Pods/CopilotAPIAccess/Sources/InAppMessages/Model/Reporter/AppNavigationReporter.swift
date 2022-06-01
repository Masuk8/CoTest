//
// Created by Michael Noy on 11/08/2021.
// Copyright (c) 2021 Zemingo. All rights reserved.
//

import Foundation

class AppNavigationReporter {

    private let reporter: ReportAPIAccess
    private let appNavigationDelegate: AppNavigationDelegate?

    init(reporter: ReportAPIAccess, appNavigationDelegate: AppNavigationDelegate?) {
        self.reporter = reporter
        self.appNavigationDelegate = appNavigationDelegate
    }

    func reportSupportedActions() {
        if let appNavigationDelegate = appNavigationDelegate {
            for command in appNavigationDelegate.getSupportedAppNavigationCommands() {
                reporter.log(event: SupportedActionsAnalyticsEvent(supportedAppNavigationCommand: command))
            }
        }
    }
}