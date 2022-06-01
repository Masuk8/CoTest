//
//  LogManager.m
//
//  Version: 1.0.83
//
//  Created by Philip Drubich on 1/27/15.
//  Copyright (c) 2015 Zemingo. All rights reserved.
//

#import "ZLogManager.h"
#import <UIKit/UIKit.h>

#pragma mark - Log file header style

//Upper section of the header
#define LogManagerNewSessionHeaderPrefixString @"\n\n\t+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
//Middle section of header
//Contains a title(and possibly current project name)
#define LogManagerNewSessionHeaderString @"\t+ ####### Log Manager - Log #######\t\t\t\t\t\t\t\t\t\t\t\t\t\t+"
//Contains timestamp of created log file
#define LogManagerNewSessionHeaderFormat @"%@%@\n\t+ Date: %@\t\t\t\t\t\t\t\t\t\t\t\t\t\t+\n"
//Contains the current application device information
#define LogManagerNewSessionHeaderGeneralInfoFormat @"\t+ General info: Device type - %@, iOS version - %@, App version - %@\t\t+\n\t+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

#pragma mark - log console colors configuration

#define FATAL_COLOR @"fg255,0,0;" //Red
#define ERROR_COLOR @"fg255,70,70;"//Slightly less prominent red
#define WARN_COLOR @"fg255,255,0;"//Yellow
#define INFO_COLOR @"fg255,255,255;"//White
#define DEBUG_COLOR @"fg180,180,180;"//Very light gray
#define LOW_COLOR @"fg128,128,128;"//Light gray
#define EXTERNAL_COLOR @"fg80,80,80;"//Dark gray

#pragma mark - XCode constants(SHOULD NOT BE CHANGED)

#define XCODE_COLORS_ENVIRONMENT_VARIABLE "XcodeColors"

//XcodeColors Setup(Constants necessary for correct functionality of XcodeColors).
#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#pragma mark - Interface

#define FILE_DOESNT_EXIST_SIZE -1

@interface ZLogManager ()

//File handle to current log file
@property (strong, atomic) NSFileHandle *logFileHandle;

//Operation queue for writing to log files
@property (strong, atomic) NSOperationQueue *fileOperationQueue;

//Logs data for a single write operation
@property (strong, atomic) NSMutableArray *logsData;

//Locking mechanism used when writing logs files
@property (strong, atomic) NSLock *logEntriesLock;

@property (strong, atomic) NSCondition *logFilesWritingCondition;

//Saves the currently managed log file paths
@property (strong, nonatomic) NSMutableArray *availableLogFilesPaths;

//Cached version of NSDate format used in console logs
@property (strong, nonatomic) NSDateFormatter *logsEntriesDateFormatter;

//Cached version of NSDate format used in log files
@property (strong, nonatomic) NSDateFormatter *logsFilesDateFormatter;

//YES - if xcodeColors is installed and NO otherwise
@property (assign, nonatomic) BOOL xCodeColorsIsInstalled;

//Runtime interface
@property (strong, nonatomic) NSMutableArray *logLevels;

@end

#pragma mark - Implementation

@implementation ZLogManager

#pragma mark - Default manager

+ (ZLogManager *) sharedManager
{
    static dispatch_once_t onceToken;
    static ZLogManager *defaultManager = nil;
    
    dispatch_once(&onceToken, ^{
        defaultManager = [[ZLogManager alloc] init];
    });
    
    return defaultManager;
}

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if (self)
    {
        if (LOG_MANAGER_XCODE_COLORS_ENABLED)
        {
            self.xCodeColorsIsInstalled = [ZLogManager isXcodeColorsInstalled];
        }
        
        [self _initRuntimeInterfaceVariables];
        
        self.logEntriesLock = [NSLock new];
        self.logsData = [[NSMutableArray alloc] init];

        self.fileOperationQueue = [[NSOperationQueue alloc] init];
        self.fileOperationQueue.maxConcurrentOperationCount = 1;
        
        self.logFilesWritingCondition = [[NSCondition alloc] init];
        
        [self _writeFilesToDiskPeriodically];
    }
    
    return self;
}

-(void) _initRuntimeInterfaceVariables
{
    self.logManagerShouldWriteToConsole = LOG_MANAGER_SHOULD_WRITE_TO_CONSOLE;
    self.logManagerShouldWriteToFile = LOG_MANAGER_SHOULD_WRITE_TO_FILE;
    
    _logManagerMinimumRuntimeLogLevel = kLogManagerDefaultLogLevel;
    _logManagerMaximumRuntimeLogLevel = kLogManagerDefaultLogLevel;
    
    self.logLevels = [[NSMutableArray alloc] init];
    
    [self.logLevels insertObject:[NSNumber numberWithBool:LOG_MANAGER_FATAL_LOGGING] atIndex:kLogManagerFatalLogLevel];

    [self.logLevels insertObject:[NSNumber numberWithBool:LOG_MANAGER_ERROR_LOGGING] atIndex:kLogManagerErrorLogLevel];
    
    [self.logLevels insertObject:[NSNumber numberWithBool:LOG_MANAGER_WARN_LOGGING] atIndex:kLogManagerWarnLogLevel];
    
    [self.logLevels insertObject:[NSNumber numberWithBool:LOG_MANAGER_INFO_LOGGING] atIndex:kLogManagerInfoLogLevel];
    
    [self.logLevels insertObject:[NSNumber numberWithBool:LOG_MANAGER_DEBUG_LOGGING] atIndex:kLogManagerDebugLogLevel];
    
    [self.logLevels insertObject:[NSNumber numberWithBool:LOG_MANAGER_LOW_LOGGING] atIndex:kLogManagerLowLogLevel];
    
    [self.logLevels insertObject:[NSNumber numberWithBool:LOG_MANAGER_EXTERNAL_LOGGING] atIndex:kLogManagerExternalLogLevel];
}

-(void) _initAvailableLogsFiles
{
    if(self.availableLogFilesPaths == nil)
    {
        [ZLogManager createLogsDirectoryIfNeeded];
        
        self.availableLogFilesPaths = [[NSMutableArray alloc] init];
        
        NSString *logsDirectory = [ZLogManager getLogsDirectory];
        
        NSArray *logFilePathsUrls = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:logsDirectory]
                   includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                        error:nil];
        
        NSArray *logFilePaths = [logFilePathsUrls valueForKeyPath:@"lastPathComponent"];
        
        logFilePaths = [self _getSortedLogFilePathsAccordingToDate:logFilePaths];
        
        [logFilePaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSString *logFilename = (NSString *)obj;
            
            NSString *fullLogFilePath = [NSString stringWithFormat:@"%@/%@", logsDirectory, logFilename];
            [self.availableLogFilesPaths addObject:fullLogFilePath];
        }];
    }
}

//Sorts log file paths in an ascending manner (from oldest creation date to the newest)
-(NSArray *) _getSortedLogFilePathsAccordingToDate:(NSArray *)logFilePaths
{
    NSArray* sortedArray = [logFilePaths sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
         NSDate* date1 = [self getDateFromFileName: obj1];
         NSDate* date2 = [self getDateFromFileName: obj2];
         return [date1 compare:date2];
    }];
    
    return sortedArray;
}

-(NSDateFormatter *)getLogsEntriesDateFormatter
{
    if(self.logsEntriesDateFormatter == nil)
    {
        self.logsEntriesDateFormatter = [[NSDateFormatter alloc] init];
        NSString *formatString = @"yyyy-MM-dd HH:mm:ss.SSS";
        [self.logsEntriesDateFormatter setDateFormat:formatString];
    }
    
    return self.logsEntriesDateFormatter;
}

-(NSDateFormatter *)getLogsFilesDateFormatter
{
    if(self.logsFilesDateFormatter == nil)
    {
        self.logsFilesDateFormatter = [[NSDateFormatter alloc] init];
        NSString *formatString = @"yyyy-MM-dd_HH-mm-ss.SSS";
        [self.logsFilesDateFormatter setDateFormat:formatString];
    }
    
    return self.logsFilesDateFormatter;
}

#pragma mark - Deallocation

- (void)dealloc
{
    NSOperationQueue *fileOperationQueue = self.fileOperationQueue;
    self.fileOperationQueue = nil;
    
    [fileOperationQueue cancelAllOperations];
    [fileOperationQueue waitUntilAllOperationsAreFinished];
    
    [self _closeCurrentLogFile];
}

#pragma mark - New log entries handling

void logString(LogManagerLogLevelType logLevel, NSString *logLevelPrefix, const char *prettyFunction,NSString *format,...)
{
    ZLogManager *logManager = [ZLogManager sharedManager];
    
    if(logManager.logManagerShouldWriteToConsole ||
       logManager.logManagerShouldWriteToFile)
    {
        BOOL shouldLogEntryBeAdded = [logManager _shouldLogEntryBeAdded:logLevel];
        
        if(shouldLogEntryBeAdded)
        {
            va_list ap;
            va_start(ap, format);
            format = [format stringByAppendingString:@"\n"];
            NSString *formatWithParameters = [[NSString alloc] initWithFormat:format arguments:ap];
            va_end(ap);
            
            NSDate *now = [NSDate date];
            NSDateFormatter *dateFormatter = [logManager getLogsEntriesDateFormatter];
            NSString *currentDateString = [dateFormatter stringFromDate:now];
            
            NSString *currentThreadID = [ZLogManager getPrettyCurrentThreadDescription];
            
            NSString *prettyFunctionString = [[NSString alloc] initWithUTF8String:prettyFunction];
            NSString *msg = [NSString stringWithFormat:@"%@%@:%@", logLevelPrefix, prettyFunctionString, formatWithParameters];
            
            msg = [NSString stringWithFormat:@"%@:%@ %@",currentDateString, currentThreadID, msg];
            
            [logManager _logString:logLevel withMessage:msg andShouldLogEntryBeAdded:shouldLogEntryBeAdded];
        }
    }
}

- (void) _logString:(LogManagerLogLevelType)logLevel
        withMessage:(NSString *)message andShouldLogEntryBeAdded:(BOOL)shouldLogEntryBeAdded
{
    [self _handleConsoleLogging:message withLogEntryShouldBeAdded:shouldLogEntryBeAdded givenLogLevel:logLevel];
    
    [self _handleFileLogging:message withLogEntryShouldBeAdded:shouldLogEntryBeAdded givenLogLevel:logLevel];
}

-(void) _handleConsoleLogging:(NSString *)message withLogEntryShouldBeAdded:(BOOL)shouldLogEntryBeAdded givenLogLevel:(LogManagerLogLevelType)logLevel
{
    if(self.logManagerShouldWriteToConsole)
    {
        if(shouldLogEntryBeAdded)
        {
            [self _printMessage:message toConsoleWithLogLevel:logLevel];
        }
    }
}

-(void) _handleFileLogging:(NSString *)message withLogEntryShouldBeAdded:(BOOL)shouldLogEntryBeAdded givenLogLevel:(LogManagerLogLevelType)logLevel
{
    if (self.logManagerShouldWriteToFile)
    {
        if(shouldLogEntryBeAdded)
        {
            [self.logEntriesLock lock];
            [self _addLogMessage:message];
            
            if(self.logsData.count >= NUM_OF_LOG_ENTRIES_BEFORE_WRITING_TO_DISK)
            {
                [self.logFilesWritingCondition signal];
            }
            
            [self.logEntriesLock unlock];
        }
    }
}

-(void) _addLogMessage:(NSString *)message
{
    [self.logsData addObject:message];
}

-(BOOL) _shouldLogEntryBeAdded:(LogManagerLogLevelType)logLevel
{
    BOOL shouldEntryBeAdded = NO;
    
    BOOL isValidLogLevel = [self _isValidLogLevel:logLevel];
    
    if(isValidLogLevel)
    {
        BOOL isLogLevelEnabled = [[self.logLevels objectAtIndex:logLevel] boolValue];
        shouldEntryBeAdded = isLogLevelEnabled;
    }
    
    return shouldEntryBeAdded;
}

+ (NSString *) getPrettyCurrentThreadDescription {
    
    NSString *currentThreadDescription;
    
    NSThread *currentThread = [NSThread currentThread];
    
    NSString *currentThreadName = currentThread.name;
    
    NSString *currentThreadNumber = [ZLogManager getThreadNumber:currentThread];
    
    //Thread name is available
    if(currentThreadName.length > 0){
        
        currentThreadDescription = [NSString stringWithFormat:@"(TID:%@, Name:%@)", currentThreadNumber, currentThreadName];
    }
    else{
        currentThreadDescription = [NSString stringWithFormat:@"(TID:%@)", currentThreadNumber];
    }
    
    return currentThreadDescription;
}

+(NSString*) getThreadNumber:(NSThread *)currentThread
{
    NSString *currentThreadNumber = 0;
    
    NSString *currentThreadInfoString = [NSString stringWithFormat:@"%@", currentThread];
    
    NSArray *firstSplit = [currentThreadInfoString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{"]];
    if ([firstSplit count] > 1) {
        NSArray *secondSplit = [firstSplit[1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"}"]];
        if ([secondSplit count] > 0)
        {
            NSArray *thirdSplit = [secondSplit[0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            {
                if ([thirdSplit count] > 0)
                {
                    NSArray *fourthSplit = [thirdSplit[0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
                    {
                        if ([fourthSplit count] > 0)
                        {
                            currentThreadNumber = [fourthSplit[1]stringByTrimmingCharactersInSet:
                                                   [NSCharacterSet whitespaceCharacterSet]];;
                        }
                    }
                }
            }
        }
    }
    
    return currentThreadNumber;
}

#pragma mark - Printing logs to console handling

-(void)_printMessage:(NSString *)message toConsoleWithLogLevel:(LogManagerLogLevelType)logLevel
{
    NSString *messageToPrint = [self _colorMessageIfNeeded:message forLogLevel:logLevel];
    const char *messageToPrintCharArray = [messageToPrint cStringUsingEncoding:[NSString defaultCStringEncoding]];
    
    printf("%s", messageToPrintCharArray);
}

-(NSString *)_colorMessageIfNeeded:(NSString *)message forLogLevel:(LogManagerLogLevelType)logLevel
{
    NSString *outputMessage = message;
    
    if (self.xCodeColorsIsInstalled)
    {
        NSString *logLevelString = nil;
        switch (logLevel)
        {
            case kLogManagerFatalLogLevel:
                logLevelString = FATAL_COLOR;
                break;
                
            case kLogManagerErrorLogLevel:
                logLevelString = ERROR_COLOR;
                break;
                
            case kLogManagerWarnLogLevel:
                logLevelString = WARN_COLOR;
                break;
                
            case kLogManagerInfoLogLevel:
                logLevelString = INFO_COLOR;
                break;
                
            case kLogManagerDebugLogLevel:
                logLevelString = DEBUG_COLOR;
                break;
                
            case kLogManagerLowLogLevel:
                logLevelString = LOW_COLOR;
                break;
                
            case kLogManagerExternalLogLevel:
                logLevelString = EXTERNAL_COLOR;
                break;
                
            default:
                break;
        }
        
        outputMessage = [NSString stringWithFormat:@"%@%@%@%@",XCODE_COLORS_ESCAPE, logLevelString, message, XCODE_COLORS_RESET];
    }
    
    return outputMessage;
}

-(NSMutableArray *) _getCurrentLogsData
{
    NSMutableArray *currentLogsData;
    
    [self.logEntriesLock lock];
    currentLogsData = [self.logsData mutableCopy];
    [self _clearLogsDataDictForNextInterval];
    [self.logEntriesLock unlock];
    
    return currentLogsData;
}

#pragma mark - Printing logs to log file or files

-(void) _writeFilesToDiskPeriodically
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    CGFloat timeToWaitBeforeWriteToDisk = LOG_MANAGER_LOG_FILES_WRITE_INTERVAL_IN_SEC;
    
    // Waits here for new log entries(even if self.logManagerShouldWriteToFile = false, in which case it will simply wait for timeout each time without executing additional operations).
    dispatch_async(queue, ^{
        
        while(true)
        {
            NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeToWaitBeforeWriteToDisk];
            [self.logFilesWritingCondition lock];
            [self.logFilesWritingCondition waitUntilDate:timeoutDate];
            [self _outputLogs];
            [self.logFilesWritingCondition unlock];
        }
    });
}

-(void) _outputLogs
{
    if(self.logManagerShouldWriteToFile)
    {
        [self.fileOperationQueue addOperationWithBlock:^{
            [self _initAvailableLogsFiles];
        }];
        
        //Write to file
        [self.fileOperationQueue addOperationWithBlock:^{
            [self _saveCurrentLogsToDisk];
        }];
    }
}

-(void) _saveCurrentLogsToDisk
{
    NSMutableArray *currentLogsDataToWrite = [self _getCurrentLogsData];
    
    if(currentLogsDataToWrite != nil && currentLogsDataToWrite.count > 0)
    {
        long numOfAppendedBytes = 0;
        NSMutableString *logFileString = [self _createLogFileString:currentLogsDataToWrite];
        numOfAppendedBytes = [self _tryAppendLogStringToCurrentLogFile:logFileString];
        
        // we'll write the remaining data (if any) to the next files
        [self _writeLogStringRemainsToNewLogFiles:logFileString
           WithNumOfBytesAppendedToCurrentLogFile:numOfAppendedBytes];
    }
}

-(NSMutableString *) _createLogFileString:(NSMutableArray *)currentLogsDataToWrite
{
    NSMutableString *logFileString = [[NSMutableString alloc] init];
    
    static dispatch_once_t onceToken;
    
    //Adds log file header once per run
    dispatch_once(&onceToken, ^{
        NSData *logFileHeaderData = [ZLogManager getHeaderData];
        NSString *logFileHeaderString = [[NSString alloc] initWithData:logFileHeaderData encoding:NSUTF8StringEncoding];
                                   
       [logFileString appendString:logFileHeaderString];
    });
    
    for(NSString *message in currentLogsDataToWrite)
    {
        [logFileString appendString:message];
    }
    
    return logFileString;
}

-(NSInteger) _tryAppendLogStringToCurrentLogFile:(NSMutableString *)logFileString
{
    long maxFileSizeInBytes = [ZLogManager getMaxFileSizeInBytes];
    long currentLogFileSizeInBytes = [self _getCurrentLogFileSize];
    long numOfBytesToAppendToLogFile = 0;
    
    //Append to log file if it exists
    if(currentLogFileSizeInBytes > FILE_DOESNT_EXIST_SIZE)
    {
        numOfBytesToAppendToLogFile = maxFileSizeInBytes - currentLogFileSizeInBytes;
        
        if(numOfBytesToAppendToLogFile > logFileString.length)
        {
            numOfBytesToAppendToLogFile = logFileString.length;
        }
        
        if(numOfBytesToAppendToLogFile > 0)
        {
            NSString *logFileStringToAppend = [logFileString substringWithRange:NSMakeRange(0, numOfBytesToAppendToLogFile)];
            
            //Appends available section to current log file if its isn't full
            [self _writeLogToCurrentFile:logFileStringToAppend];
        }
    }
    //create first file and append to it
    else
    {
        numOfBytesToAppendToLogFile = maxFileSizeInBytes;
        
        if(numOfBytesToAppendToLogFile > logFileString.length)
        {
            numOfBytesToAppendToLogFile = logFileString.length;
        }
        
        [self _writeToNewLogFile:logFileString
        withNumberOfBytesToWrite:numOfBytesToAppendToLogFile andTotalWrittenBytes:0];
    }
    
    return numOfBytesToAppendToLogFile;
}

-(void) _writeLogStringRemainsToNewLogFiles:(NSMutableString *)logFileString WithNumOfBytesAppendedToCurrentLogFile:(NSInteger)numOfBytesAppendedToLogFile
{
    long maxFileSizeInBytes = [ZLogManager getMaxFileSizeInBytes];
    
    long remainingBytesToWrite = logFileString.length - numOfBytesAppendedToLogFile;
    long totalWrittenBytes = numOfBytesAppendedToLogFile;
    
    while (remainingBytesToWrite > 0)
    {
        NSInteger numOfBytesToWriteToLogFile = 0;
        
        if(remainingBytesToWrite < maxFileSizeInBytes)
        {
            numOfBytesToWriteToLogFile = remainingBytesToWrite;
        }
        else
        {
            numOfBytesToWriteToLogFile = maxFileSizeInBytes;
        }
        
        [self _createAdditionalLogFile:logFileString WithNumOfBytesToWriteToCurrentLogFile:numOfBytesToWriteToLogFile WithTotalWrittenBytes:totalWrittenBytes];
        
        totalWrittenBytes += numOfBytesToWriteToLogFile;
        remainingBytesToWrite -= numOfBytesToWriteToLogFile;
    }
}

-(void) _createAdditionalLogFile:(NSMutableString *)logFileString
WithNumOfBytesToWriteToCurrentLogFile:(long)numOfBytesToWriteToLogFile
           WithTotalWrittenBytes:(long)totalWrittenBytes
{
    if(self.availableLogFilesPaths.count >= LOG_MANAGER_MAX_NUM_OF_LOG_FILES)
    {
        [self _deleteOldestLogFile];
    }
    
    [self _writeToNewLogFile:logFileString withNumberOfBytesToWrite:numOfBytesToWriteToLogFile andTotalWrittenBytes:totalWrittenBytes];
}

-(void) _writeToNewLogFile:(NSString *)logFileString withNumberOfBytesToWrite:(long)numOfBytesToWrite andTotalWrittenBytes:(long)totalWrittenBytes
{
    NSString *newLogFilePath = [self _getNewLogFileFullPath];
    
    // new file
    [self.availableLogFilesPaths addObject:newLogFilePath];
    
    NSString *logFileStringToWrite = [logFileString substringWithRange:NSMakeRange(totalWrittenBytes, numOfBytesToWrite)];
    
    //Appends available section to current log file if its isn't full
    [self _writeLogToCurrentFile:logFileStringToWrite];
}

-(void) _clearLogsDataDictForNextInterval
{
    [self.logsData removeAllObjects];
}

-(long) _getCurrentLogFileSize
{
    long fileSize = FILE_DOESNT_EXIST_SIZE;
    
    NSError *attributesError = nil;
    
    NSString *fileFullPath = [self _getCurrentLogFileFullPath];
    
    if(fileFullPath != nil)
    {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileFullPath error:&attributesError];
        
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        fileSize = [fileSizeNumber longValue];
    }
    
    return fileSize;
}

-(NSString *) _getCurrentLogFileFullPath
{
    NSString *logFilePath = nil;
    
    if(self.availableLogFilesPaths.count > 0)
    {
        logFilePath = [self.availableLogFilesPaths lastObject];
    }
    
    return logFilePath;
}

-(NSString *) _getNewLogFileFullPath
{
    NSString *logFilePath = nil;
    
    NSString *prefix = LOG_MANAGER_LOG_FILES_PREFIX;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSDictionary *mainBundleinfoDict = [mainBundle infoDictionary];

    NSString *bundleName=[mainBundleinfoDict objectForKey:@"CFBundleName"];
    NSString *bundleVersion = [mainBundleinfoDict objectForKey:@"CFBundleShortVersionString"];
    NSNumber *buildNumber = [mainBundleinfoDict objectForKey:@"CFBundleVersion"];
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [self getLogsFilesDateFormatter];
    
    NSString *currentDateString = [dateFormatter stringFromDate:now];
    
    // see also getDateFromFileName
    logFilePath = [NSString stringWithFormat:@"%@_%@_%@:%@_%@%@", prefix, currentDateString,bundleName, bundleVersion, buildNumber,LOG_MANAGER_LOG_FILES_EXTENSION];
    
    NSString *filePath = [[ZLogManager getLogsDirectory] stringByAppendingPathComponent:logFilePath];
    
    return filePath;
}

-(NSDate*) getDateFromFileName: (NSString*) fileName{
    // see _getNewLogFileFullPath
    // this is the expected structure: log_2018-02-18_11-30-38.178_SampleApp:1.0_1.log
    NSArray* splitName = [fileName componentsSeparatedByString:@"_"];
    if (splitName.count <4){
        return nil;
    }
    NSString* date = splitName[1];
    NSString* time = splitName[2];
    NSString* concatenatedString = [NSString stringWithFormat:@"%@_%@", date, time];
    NSDateFormatter *dateFormatter = [self getLogsFilesDateFormatter];
    
    NSDate* calculatedDate = [dateFormatter dateFromString: concatenatedString];
    return calculatedDate;
}

- (void)_openCurrentLogFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *logFilePath = [self _getCurrentLogFileFullPath];
    
    BOOL isDirectory;
    if (![fileManager fileExistsAtPath:logFilePath isDirectory:&isDirectory])
    {
        [fileManager createFileAtPath:logFilePath contents:nil attributes:nil];
        NSURL *logFileURL = [NSURL fileURLWithPath:logFilePath];
        [logFileURL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
    }    
    
    if (!self.logFileHandle) {
        self.logFileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    }
}

- (void)_closeCurrentLogFile
{
    if (self.logFileHandle) {
        [self.logFileHandle closeFile];
        self.logFileHandle = nil;
    }
}

- (void) _writeLogToCurrentFile:(NSString *)log
{
    [self _openCurrentLogFile];
    
    NSData *logData = [log dataUsingEncoding:NSUTF8StringEncoding];
    
    @try
    {
        [self.logFileHandle seekToEndOfFile];
        [self.logFileHandle writeData:logData];
    }
    @catch (NSException *exception) {
        // TODO: in case of such failure, writing to the file should be stalled until a precondition is met
        // printing here to the log can create an endless loop
//        LogWarn(@"Error Writing to file: %@", exception);
    }
    @finally
    {
        @try
        {
            [self _closeCurrentLogFile];
        }
        @catch (NSException *exception) {
            // printing here to the log can create an endless loop
//            LogWarn(@"Error Closing file: %@", exception);
        }
    }
}

- (void) _deleteOldestLogFile
{
    if(self.availableLogFilesPaths.count > 0)
    {
        NSString *oldestLogFilePath = [self.availableLogFilesPaths firstObject];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL isDirectory;
        if ([fileManager fileExistsAtPath:oldestLogFilePath isDirectory:&isDirectory]) {
            [fileManager removeItemAtPath:oldestLogFilePath error:nil];
        }
        
        [self.availableLogFilesPaths removeObject:oldestLogFilePath];
    }
}

#pragma mark - Utility functions aiding printing to log file or files

+(long) getMaxFileSizeInBytes
{
    NSInteger bytesInKB = 1024;
    return LOG_MANAGER_MAX_SIZE_OF_EACH_LOG_FILE_IN_KB * bytesInKB;
}

+(void) createLogsDirectoryIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *logsDirectoryPath = [ZLogManager getLogsDirectory];
    
    BOOL isDirectory = YES;
    if (![fileManager fileExistsAtPath:logsDirectoryPath isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:logsDirectoryPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSURL *logFileURL = [NSURL fileURLWithPath:logsDirectoryPath];
    [logFileURL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

+(NSString *) getLogsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logsDirectory = LOG_MANAGER_LOG_FILES_DIRECTORY;
    
    NSString *logsFilePathWithDirectory = [documentsDirectory stringByAppendingPathComponent:logsDirectory];
    
    return logsFilePathWithDirectory;
}

+(NSData *) getHeaderData
{
    NSString *header = [NSString stringWithFormat:LogManagerNewSessionHeaderFormat, LogManagerNewSessionHeaderPrefixString, LogManagerNewSessionHeaderString, [NSDate date]];
    
    //Add general info to the header
    NSString *deviceType = [UIDevice currentDevice].model;
    NSString *currentOS = [UIDevice currentDevice].systemVersion;
    NSString *bundleVersion = nil;
    
    //Get the bundle version
    NSBundle *mainBundle = [NSBundle mainBundle];
    id bundleVersionObject = mainBundle.infoDictionary[(NSString *)kCFBundleVersionKey];
    if ([bundleVersionObject isKindOfClass:[NSString class]]) {
        bundleVersion = (NSString *)bundleVersionObject;
    }
    NSString *generalInfo = [NSString stringWithFormat:LogManagerNewSessionHeaderGeneralInfoFormat, deviceType, currentOS, bundleVersion];
    
    header = [header stringByAppendingString:generalInfo];
    NSData *headerData = [header dataUsingEncoding:NSUTF8StringEncoding];
    return headerData;
}

+(BOOL) isXcodeColorsInstalled
{
    BOOL isXcodeColorsInstalled = NO;
    
    char *xcode_colors = getenv(XCODE_COLORS_ENVIRONMENT_VARIABLE);
    if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
    {
        isXcodeColorsInstalled = YES;
    }
    
    return isXcodeColorsInstalled;
}

+(NSString *) getCurrentUserName
{
    NSString *userName = nil;
    
    NSArray *bundlePathComponents = [NSBundle.mainBundle.bundlePath pathComponents];
    
    if (bundlePathComponents.count >= 3
        && [bundlePathComponents[0] isEqualToString:@"/"]
        && [bundlePathComponents[1] isEqualToString:@"Users"])
    {
        userName = bundlePathComponents[2];
    }
    
    return userName;
}

#pragma mark - Runtime interface

-(void) setLogManagerMinimumRuntimeLogLevel:(LogManagerLogLevelType)minLogLevel
{
    BOOL isValidLogLevel = [self _isValidLogLevel:minLogLevel];
    
    if(isValidLogLevel)
    {
        LogManagerLogLevelType maxLogLevel = _logManagerMaximumRuntimeLogLevel;
        
        if(maxLogLevel != kLogManagerDefaultLogLevel)
        {
            if(maxLogLevel > minLogLevel)
            {
                maxLogLevel = kLogManagerFatalLogLevel;
            }
        }
        else
        {
            maxLogLevel = kLogManagerFatalLogLevel;
        }
        
        [self _setShownLogLevelsBounds:minLogLevel withMaxLogLevel:maxLogLevel];
        
        
        _logManagerMinimumRuntimeLogLevel = minLogLevel;
        _logManagerMaximumRuntimeLogLevel = maxLogLevel;
    }
}

-(void) setLogManagerMaximumRuntimeLogLevel:(LogManagerLogLevelType)maxLogLevel
{
    
    BOOL isValidLogLevel = [self _isValidLogLevel:maxLogLevel];
    
    if(isValidLogLevel)
    {
        LogManagerLogLevelType minLogLevel = _logManagerMinimumRuntimeLogLevel;
        
        if(minLogLevel != kLogManagerDefaultLogLevel)
        {
            if(minLogLevel >  maxLogLevel)
            {
                minLogLevel = kLogManagerExternalLogLevel;
            }
        }
        else
        {
            minLogLevel = kLogManagerExternalLogLevel;
        }
        
        [self _setShownLogLevelsBounds:minLogLevel withMaxLogLevel:maxLogLevel];        
        
        _logManagerMinimumRuntimeLogLevel = minLogLevel;
        _logManagerMaximumRuntimeLogLevel = maxLogLevel;
    }
}

-(void) _setShownLogLevelsBounds:(LogManagerLogLevelType)minLogLevel withMaxLogLevel:(LogManagerLogLevelType)maxLogLevel
{
    //Smaller than range logs will not be active
    for(int i = 0; i < maxLogLevel; i++)
    {
        NSNumber *newLogLevelValue = [NSNumber numberWithBool:NO];
        [self.logLevels replaceObjectAtIndex:i withObject:newLogLevelValue];
    }
    
    //logs in logs range (between maxLogLevel and minlogLevel) will be active.
    for(int i = maxLogLevel; i <= minLogLevel; i++)
    {
        NSNumber *newLogLevelValue = [NSNumber numberWithBool:YES];
        [self.logLevels replaceObjectAtIndex:i withObject:newLogLevelValue];
    }
    
    //Larger than range logs will not be active
    for(int i = minLogLevel + 1; i < kLogManagerDefaultLogLevel; i++)
    {
        NSNumber *newLogLevelValue = [NSNumber numberWithBool:NO];
        [self.logLevels replaceObjectAtIndex:i withObject:newLogLevelValue];
    }
}

-(BOOL) _isValidLogLevel:(NSInteger)logLevelCandidate
{
    BOOL isValid = YES;
    
    if(logLevelCandidate < kLogManagerFatalLogLevel ||
       logLevelCandidate > kLogManagerExternalLogLevel)
    {
        isValid = NO;
    }
    
    return isValid;
}

- (void) logMessage:(NSString*)message withLevel:(LogManagerLogLevelType)level function:(const char*)function andPrefix:(NSString*)prefix
{
    logString(level, prefix, function, message);
}

@end

