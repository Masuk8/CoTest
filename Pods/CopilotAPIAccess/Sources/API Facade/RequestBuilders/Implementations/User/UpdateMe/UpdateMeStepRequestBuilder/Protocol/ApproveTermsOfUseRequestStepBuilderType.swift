//
//  ApproveTermsOfUseRequestStepBuilderType.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 10/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public protocol ApproveTermsOfUseRequestStepBuilderType {
    /// Approve terms of use passing their current version as parameter.
    func approveTermsOfUse(forVersion version: String) -> RequestBuilder<Void, ApproveTermsOfUseError>
}
