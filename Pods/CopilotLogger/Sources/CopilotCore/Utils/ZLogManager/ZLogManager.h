//
//  ZLogManager:
//
//  Version: 1.0.83
//
//  Enables synchronous logging to console/file according to multiple logging levels.
//
//  Main Implemented Features:
//  - Login Levels: Fatal, Error, Warn, Info, Debug, Low, External.
//
//  - Custom Configurations for:
//    1)Output to console YES/NO.
//    2)Output to file YES/NO.
//    3)Single Maximum Log File Size (Default: 1024 KB).
//    4)Maximum Number of Log Files(Default: 10).
//    5)Colors in terminal YES/NO (Default: YES).
//    6)Log file prefix: (Default: log).
//    7)Log files directory(Default: /Logs).
//    8)Log file extension(Default: .log).
//    9)Wrapping of external logging(Specifically NSLog).
//    10)Ability to change a color associated with each logging level(located within ZLogManager.m and
//       requires XcodeColors to be enabled).
//
//  Created by Philip Drubich on 2/11/15.
//  Copyright (c) 2015 Zemingo. All rights reserved.
//
// Note as part of CopilotAuth:
// ZLogManager.h target membership must be public. This is because we use ZLogManagerSwiftWrapper.swift and bridging header file is not supported in frameworks.


@import Foundation;

@interface ZLogManager : NSObject

#pragma mark - Configuration (internal)
typedef NS_ENUM(NSInteger, LogManagerLogLevelType)
{
    kLogManagerFatalLogLevel    = 0,
    kLogManagerErrorLogLevel    = 1,
    kLogManagerWarnLogLevel     = 2,
    kLogManagerInfoLogLevel     = 3,
    kLogManagerDebugLogLevel    = 4,
    kLogManagerLowLogLevel      = 5,
    kLogManagerExternalLogLevel = 6,
    kLogManagerDefaultLogLevel  = 7,
};

// c function for storing and printing logs
void logString(LogManagerLogLevelType logLevel, NSString *logLevelPrefix, const char *prettyFunction,NSString *format,...);

#pragma mark - Runtime Interface
// Runtime interface:
// Usage:
// 1)Reference the log manager in the following manner:
//   ZLogManager *logManager = [ZLogManager sharedManager];
// 2)use one of the provided API functions to change log levels
//   functionality or enable/disable write to console/file at runtime.

// Shared instance
+ (ZLogManager *) sharedManager;

// To be used for extending the log manager
- (void) logMessage:(NSString*)message withLevel:(LogManagerLogLevelType)level function:(const char*)function andPrefix:(NSString*)prefix;

+ (NSString *) getLogsDirectory;

// Enables/Disables writing to console in runtime
@property (assign, nonatomic) BOOL                   logManagerShouldWriteToConsole;

// Enables/Disables writing to file in runtime
@property (assign, atomic   ) BOOL                   logManagerShouldWriteToFile;

// Minimum enabled log level - all log levels above this are turned on(bounded from top by max log level)
// By Default it will be the External log level.
@property (assign, nonatomic) LogManagerLogLevelType logManagerMinimumRuntimeLogLevel;

// Maximum enabled log level - all log levels bellow this are turned on(bounded from bottom by min log level)
// By Default it will be the Fatal log level.
@property (assign, nonatomic) LogManagerLogLevelType logManagerMaximumRuntimeLogLevel;

@end

#pragma mark - Log Levels Setup
#pragma mark Log to console options
// Enables/Disables writing of logs to console
#define LOG_MANAGER_SHOULD_WRITE_TO_CONSOLE     1

#pragma mark Log to file options
// Enables/Disables writing of logs to an external file on disk
#define LOG_MANAGER_SHOULD_WRITE_TO_FILE        0

// Log files settings
#define LOG_MANAGER_MAX_NUM_OF_LOG_FILES                10
#define LOG_MANAGER_MAX_SIZE_OF_EACH_LOG_FILE_IN_KB     1024

#pragma mark Log levels ON/OFF setup
// A critical error that is logged when something fatal in the application lifecycle had happened and the application cannot
// live/will malfunction in the current state.
// Example: we've failed to initialize the core data db, and the application is based on that local db.
#define LOG_MANAGER_FATAL_LOGGING               1

// Logs mistakes done by developers (client or server) which result in undesirable flows.
// If we've done everything right, and we shouldn't reach a certain flow - we should have an error log that marks that flow.
// For example: We expected to parse a value from server as a string, and we got something else, we should log it as an error
// since it might indicate a problem with the API or the client-side parsing method.
#define LOG_MANAGER_ERROR_LOGGING               1

// This is an error which is a part of the flow. We've expected it, but we should take note that it had happened.
// For example: Unable to reach a hardware device (due to a valid reason), or unable to reach the server since there's no
// internet connection.
#define LOG_MANAGER_WARN_LOGGING                1

// A way to give a title to the flow. Should not log errors, but indicate major changes that happened, or a flow that has
// started or finished.
// For example: 'Started playing video', 'Obtaining configuration', or 'Performing Facebook login'.
#define LOG_MANAGER_INFO_LOGGING                1

// Used for debug-time, in order to track the flow of the application.
// For example: when calling server APIs, log the URL of the call + it's parameters, and log when you've got a response.
#define LOG_MANAGER_DEBUG_LOGGING               0

// Used for low-level debugging, when there's usually a lot of data involved.
// For example: when calling server APIs that should return a lot of data, we'll log the response values as low-level.
#define LOG_MANAGER_LOW_LOGGING                 0

#pragma mark External libraries log wrapping
// Will allow to turn ON/OFF according to the 'SHOW_EXTERNAL_LOGS' macro which wraps NSLog.
// Used in order to enable/disable logs of external components (which use NSLog).
//
// NOTE: This will not work on pre-compiled libraries.
#define LOG_MANAGER_EXTERNAL_LOGGING            0

// Enables/Disables the external logs system (NSLog, etc.)
// When enabled NSLog will feature its original functionality.
// When Disabled NSLog will be replaced by the LogExternal command of the LogManager.
//
// NOTE: This will not work on pre-compiled libraries.
#define LOG_MANAGER_WRAP_EXTERNAL_LOGS          0

#pragma mark - Log to Files Advanced Options
// Log files extensions
#define LOG_MANAGER_LOG_FILES_DIRECTORY                 @"Logs"
#define LOG_MANAGER_LOG_FILES_PREFIX                    @"log"
#define LOG_MANAGER_LOG_FILES_EXTENSION                 @".log"

// Maximum time between each write of log entries to log file on disk
#define LOG_MANAGER_LOG_FILES_WRITE_INTERVAL_IN_SEC     0.5f
// Maximum number of log file entries gathered before writing to log files on disk
#define NUM_OF_LOG_ENTRIES_BEFORE_WRITING_TO_DISK       10

#pragma mark - XCodeColors (LLDB Console Colors) Support
// Enables/Disables colors on console (also dependant upon installation state of XcodeColors and addtion of XcodeColors envoirment variable)
#define LOG_MANAGER_XCODE_COLORS_ENABLED                1

#pragma mark - Log Levels Macros
#define FATAL_PREFIX @"[:FATAL:]:"
#define LogFatal(format...) logString(kLogManagerFatalLogLevel,FATAL_PREFIX,__PRETTY_FUNCTION__,format);

#define ERROR_PREFIX @"[:ERROR:]:"
#define LogErr(format...) logString(kLogManagerErrorLogLevel, ERROR_PREFIX, __PRETTY_FUNCTION__, format);

#define WARN_PREFIX @"[:WARN:]:"
#define LogWarn(format...) logString(kLogManagerWarnLogLevel, WARN_PREFIX, __PRETTY_FUNCTION__, format);

#define INFO_PREFIX @"[:INFO:]:"
#define LogInfo(format...) logString(kLogManagerInfoLogLevel, INFO_PREFIX,__PRETTY_FUNCTION__, format);

#define DEBUG_PREFIX @"[:DEBUG:]:"
#define LogDebug(format...) logString(kLogManagerDebugLogLevel, DEBUG_PREFIX,__PRETTY_FUNCTION__, format);

#define LOW_PREFIX @"[:LOW:]:"
#define LogLow(format...) logString(kLogManagerLowLogLevel, LOW_PREFIX,__PRETTY_FUNCTION__, format);

#define EXTERNAL_PREFIX @"[:EXTERN:]:"
#define LogExternal(format...) logString(kLogManagerExternalLogLevel, EXTERNAL_PREFIX,__PRETTY_FUNCTION__, format);

#if LOG_MANAGER_WRAP_EXTERNAL_LOGS
#define NSLog(format...) LogExternal(format);
#endif
