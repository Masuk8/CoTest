//
//  SimpleBaseEventLogProvider.swift
//  CopilotAPIAccess
//
//  Created by Michael Noy on 03/11/2021.
//  Copyright © 2021 Zemingo. All rights reserved.
//

import Foundation
public class SimpleBaseEventLogProvider: EventLogProvider{
    
    private var userId: String? = nil
    
    private let externalEventLogger : ExternalEventLogger
    
    public init(externalEventLogger : ExternalEventLogger){
        self.externalEventLogger = externalEventLogger
    }
    
    public var providerName: String {
        return "SimpleBaseEventLogProvider"
    }
    
    public func enable() {
        // No action required
    }

    public func disable() {
        // No action required
    }

    public func setUserId(userId:String?){
        self.userId = userId
    }
    
    public func transformParameters(parameters: Dictionary<String, String>) -> Dictionary<String, String> {
        return parameters
    }
    
    public func logCustomEvent(eventName: String, transformedParams: Dictionary<String, String>) {
        externalEventLogger.logCustomEvent(userId: userId, eventName:eventName, parameters: transformedParams)
    }
}

public protocol ExternalEventLogger{
    func logCustomEvent(userId: String?, eventName: String, parameters: Dictionary<String, String>)
}

