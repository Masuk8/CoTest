//
//  ApproveTermsOfUseRequestExecuter.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 25/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

class ApproveTermsOfUseRequestExecuter: RequestExecuter<Void, ApproveTermsOfUseError> {
    
    typealias Dependencies = HasAuthenticationServiceInteraction & HasUserServiceInteraction & HasReporter
    private let dependencies: Dependencies
    
    private let version: String
    
    init(version: String, dependencies: Dependencies) {
        self.version = version
        self.dependencies = dependencies
        super.init()
    }
    
    override func execute(_ closure: @escaping (Response<Void, ApproveTermsOfUseError>) -> Void) {
        dependencies.authenticationServiceInteraction.approveTermsOfUse(for: version) { (response) in
            switch response {
            case .success:
                // closure should not be weak because no one hold it strongly to send analytics report
                self.dependencies.userServiceInteraction.me(getCurrentUserClosure: { (_) in
                    self.dependencies.reporter.log(event: AcceptTermsAnalyticsEvent(version: self.version))
                    closure(response)
                })
            default:
                closure(response)
            }
        }        
    }
}
