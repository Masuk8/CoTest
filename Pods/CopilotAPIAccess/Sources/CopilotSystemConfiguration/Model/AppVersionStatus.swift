//
//  AppVersionStatus.swift
//  SystemConfigurationComponent
//
//  Created by Yulia Felberg on 23/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

public class AppVersionStatus {
    
    public enum VersionStatus: String {
        case ok = "OK"
        case notSupported = "NotSupported"
        case newVersionRecommended = "NewVersionRecommended"
    }
    
    private struct Constants {
        static let storeUrlKey = "storeUrl"
        static let statusKey = "status"
    }
    
    public let versionStatus: VersionStatus
    
    //MARK: Init
    
    private init() {
        versionStatus = .notSupported
    }

    init?(withDictionary dictionary: [String: Any]) {
        guard let versionStatusFromDict = dictionary[Constants.statusKey] as? String else {
            ZLogManagerWrapper.sharedInstance.logError(message: "unable to parse dictionary to authentication credentials with dict: \(dictionary)")
            return nil
        }
        
        if let versionStatus = VersionStatus(rawValue: versionStatusFromDict){
            self.versionStatus = versionStatus
        }else {
            ZLogManagerWrapper.sharedInstance.logError(message: "unable to create AppVersionStatus: got not supported VersionStatus")
            return nil
        }
    }
}
