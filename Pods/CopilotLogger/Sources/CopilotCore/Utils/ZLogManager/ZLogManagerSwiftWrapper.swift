//
//  ZLogManagerSwiftWrapper.swift
//  Reali
//
//  Created by Guy Chen on 2/3/16.
//  Copyright © 2016 Zemingo. All rights reserved.
//

import Foundation

public class ZLogManagerWrapper {
    
    public static let sharedInstance = ZLogManagerWrapper()
    
    public required init() {
        ZLogManager.shared().logManagerMaximumRuntimeLogLevel = .fatalLogLevel
        ZLogManager.shared().logManagerMinimumRuntimeLogLevel = .lowLogLevel
    }
    
    public func setRuntime(minLogLevelType minimum: LogManagerLogLevelType, maxLogLevelType maximium: LogManagerLogLevelType){
        ZLogManager.shared().logManagerMaximumRuntimeLogLevel = maximium
        ZLogManager.shared().logManagerMinimumRuntimeLogLevel = minimum
    }
    
    public func getLogsDirectory() -> String{
        return  ZLogManager.getLogsDirectory()
    }
    
    public func shouldWriteToFile(_ writeToFile: Bool){
        ZLogManager.shared().logManagerShouldWriteToFile = writeToFile
    }
    
    public func logFatal(message: String!, functionName: String = #function) {
        ZLogManager.shared().logMessage(message, with: .fatalLogLevel, function: functionName, andPrefix: FATAL_PREFIX)
    }
    
    public func logError(message: String!, functionName: String = #function) {
        ZLogManager.shared().logMessage(message, with: .errorLogLevel, function: functionName, andPrefix: ERROR_PREFIX)
    }
    
    public func logWarning(message: String!, functionName: String = #function) {
        ZLogManager.shared().logMessage(message, with: .warnLogLevel, function: functionName, andPrefix: WARN_PREFIX)
    }
    
    public func logInfo(message: String!, functionName: String = #function) {
        ZLogManager.shared().logMessage(message, with: .infoLogLevel, function: functionName, andPrefix: INFO_PREFIX)
    }
    
    public func logDebug(message: String!, functionName: String = #function) {
        ZLogManager.shared().logMessage(message, with: .debugLogLevel, function: functionName, andPrefix: DEBUG_PREFIX)
    }
    
    public func logLow(message: String!, functionName: String = #function) {
        ZLogManager.shared().logMessage(message, with: .lowLogLevel, function: functionName, andPrefix: LOW_PREFIX)
    }
}
