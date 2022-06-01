//
//  EmailVerificationStatus.swift
//  CopilotAPIAccess
//
//  Created by Adaya on 07/03/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

public enum EmailVerificationStatus : String {
    ////emailVerificationStatus (string, optional) = ['Unset', 'Pending', 'Verified']
    case unknown
    case unset = "Unset"
    case pending = "Pending"
    case verified = "Verified"
}
