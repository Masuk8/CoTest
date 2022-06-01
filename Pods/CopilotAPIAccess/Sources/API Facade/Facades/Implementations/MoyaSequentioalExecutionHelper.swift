//
//  MoyaSession.swift
//  CopilotAPIAccess
//
//  Created by Elad on 05/04/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation
import Moya

class MoyaSequentialExecutionHelper {
    
    let session: Session
    let queue: OperationQueue
    
    init() {
        session = Session()
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
    }
}


