//
//  SystemConfigurationServiceInteraction.swift
//  SystemConfigurationComponent
//
//  Created by Yulia Felberg on 22/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

typealias GetConfigurationClosure = (Response<Configuration, FetchConfigurationError>) -> Void
typealias UpgradeCheckClosure = (Response<AppVersionStatus, CheckAppVersionStatusError>) -> Void

protocol SystemConfigurationServiceInteractable {
    func checkIfUpgradeRequired(appVersion: String, upgradeCheckClosure: @escaping UpgradeCheckClosure)
    func getConfiguration(getConfigurationClosure: @escaping GetConfigurationClosure)
}

class SystemConfigurationServiceInteraction {
    
    fileprivate var requestExecuter: RequestExecutor<SystemConfigurationService>
    
    // MARK: - Init
    
    init(sequentialExecutionHelper: MoyaSequentialExecutionHelper) {
        requestExecuter = RequestExecutor(sequentialExecutionHelper: sequentialExecutionHelper)
    }
    
    // MARK: - Private
    
    fileprivate func handleGetConfigurationExecuterResult(_ response: RequestExecutorResponse, getConfigurationClosure: GetConfigurationClosure) {
        var getConfigurationResponse: Response<Configuration, FetchConfigurationError>
        
        switch response {
        case .failure(error: let serverError):
            getConfigurationResponse = .failure(error: FetchConfigurationErrorResolver().resolve(serverError))
        
        case .success(payload: let dictionary):
            if let configuration = Configuration(withDictionary: dictionary) {
                getConfigurationResponse = .success(configuration)
            }
            else {
                getConfigurationResponse = .failure(error: .generalError(debugMessage: "Failed to create Configuration from response \(dictionary)"))
                ZLogManagerWrapper.sharedInstance.logError(message: "Failed to create Configuration from response \(dictionary)")
            }
        }
        
        getConfigurationClosure(getConfigurationResponse)
    }
    
    fileprivate func handleCheckUpgradeExecuterResult(_ response: RequestExecutorResponse, checkUpgradeClosure: UpgradeCheckClosure) {
        var checkUpgradeResponse: Response<AppVersionStatus, CheckAppVersionStatusError>
        
        switch response {
        case .failure(error: let serverError):
           
            checkUpgradeResponse = .failure(error: CheckAppVersionStatusErrorResolver().resolve(serverError))
        
        case .success(payload: let dictionary):
            
            if let versionStatus = AppVersionStatus(withDictionary: dictionary) {
                checkUpgradeResponse = .success(versionStatus)
            }
            else {
                checkUpgradeResponse = .failure(error: .generalError(debugMessage: "Failed to create AppVersionStatus from response"))
                ZLogManagerWrapper.sharedInstance.logError(message: "Failed to create AppVersionStatus from response \(dictionary)")
            }
        }
        
        checkUpgradeClosure(checkUpgradeResponse)
    }
}

extension SystemConfigurationServiceInteraction: SystemConfigurationServiceInteractable {
    
    func checkIfUpgradeRequired(appVersion: String, upgradeCheckClosure: @escaping UpgradeCheckClosure) {
        let checkUpgradeService = SystemConfigurationService.checkIfAppUpgradeRequired(appVersion: appVersion)
        requestExecuter.executeRequest(target: checkUpgradeService) {  [weak self] (requestExecuterResponse) in
            self?.handleCheckUpgradeExecuterResult(requestExecuterResponse, checkUpgradeClosure: upgradeCheckClosure)
        }
    }
    
    func getConfiguration(getConfigurationClosure: @escaping GetConfigurationClosure) {
        let getConfigurationService = SystemConfigurationService.getConfiguration
        requestExecuter.executeRequest(target: getConfigurationService) { [weak self] (requestExecuterResponse) in
            self?.handleGetConfigurationExecuterResult(requestExecuterResponse, getConfigurationClosure: getConfigurationClosure)
        }
    }
}
