//
//  NullLogoutRequestBuilder.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 29/07/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

class NullLogoutRequestBuilder: NullRequestBuilder<Void, LogoutError>, MarkForDeletionRequestStepBuilderType {
    
    var markForDeletion: RequestBuilder<Void, ConsentRefusedError> = NullRequestBuilder<Void, ConsentRefusedError>()
    
}
