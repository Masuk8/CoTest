//
//  MarkForDeletionRequestStepBuilderType.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 09/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

public protocol MarkForDeletionRequestStepBuilderType {
    var markForDeletion: RequestBuilder<Void, ConsentRefusedError> { get }
}
