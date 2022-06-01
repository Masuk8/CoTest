//
//  UserServiceInteraction.swift
//  Users
//
//  Created by Yulia Felberg on 25/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

protocol UserServiceInteractable {
    var me: UserMe? { get }
    func me(getCurrentUserClosure: @escaping GetCurrentUserClosure)
    func updateUser(id: String, userInfo: UserInfo?, customSettings: [String: Any]?, updateUserClosure: @escaping UpdateUserClosure)
    func updateDeviceDetails(copilotSdkVersion: String, pnsToken: Data, isSandbox: Bool, updateCurrentDeviceClosure: @escaping UpdateDeviceDetailsClosure)
    func deleteMe(deleteUserClosure: @escaping (Response<Void, DeleteUserError>) -> Void)
}

internal class UserServiceInteraction {

    fileprivate let authenticatedRequestExecuter: AuthenticatedRequestExecutor<UserService>
    
    private(set) var me: UserMe?
    
    private let configurationProvider: ConfigurationProvider
    public var authenticationApi: AuthenticationServiceInteractable

    // MARK: - Init
    internal init(authenticationProvider: AuthenticationApi, configurationProvider: ConfigurationProvider, sequentialExecutionHelper: MoyaSequentialExecutionHelper) {
        authenticationApi = authenticationProvider
        authenticatedRequestExecuter = AuthenticatedRequestExecutor<UserService>(authenticationProvider: authenticationProvider, sequentialExecutionHelper: sequentialExecutionHelper)
        self.configurationProvider = configurationProvider
    }
    
    //MARK: - Private
    
    fileprivate func handleGetCurrentUserExecuterResult(_ response: RequestExecutorResponse, getCurrnetUserClosure: GetCurrentUserClosure) {
        var getCurrentUserResponse: Response<UserMe, FetchMeError>
        
        switch response {
        case .failure(error: let serverError):
            getCurrentUserResponse = .failure(error: FetchMeErrorResolver().resolve(serverError))
        case .success(payload: let dictionary):
            
            if let user = UserMe(withDictionary: dictionary) {
                me = user
                addUserGeneralParamsToAnalytics(userMe: user)
                handleAnalyticsConsent(from: user)
                getCurrentUserResponse = .success(user)
            }
            else {
                getCurrentUserResponse = .failure(error: .generalError(debugMessage: "Failed to create user from dictionary"))
            }
        }
        
        getCurrnetUserClosure(getCurrentUserResponse)
    }
    
    fileprivate func handleUpdateUserExecuterResult(_ response: RequestExecutorResponse, updateUserClosure: UpdateUserClosure) {
        var updateUserResponse: Response<UserMe, UpdateUserDetailsError>
        
        switch response {
        case .failure(error: let serverError):
            updateUserResponse = .failure(error: UpdateUserDetailsErrorResolver().resolve(serverError))
        case .success(payload: let dictionary):
            
            if let user = UserMe(withDictionary: dictionary) {
                me = user
                addUserGeneralParamsToAnalytics(userMe: user)
                handleAnalyticsConsent(from: user)
                updateUserResponse = .success(user)
            }
            else {
                updateUserResponse = .failure(error: .generalError(debugMessage: "Failed to create user from dictionary"))
            }
        }
        
        updateUserClosure(updateUserResponse)
    }
    
    fileprivate func handleUpdateCurrentDeviceExecutorResult(_ response: RequestExecutorResponse, updateCurrentDeviceClosure: UpdateDeviceDetailsClosure) {
        var updateCurrentDeviceResponse: Response<Void, UpdateDeviceDetailsError>
        
        switch response {
        case .failure(error: let serverError):
            updateCurrentDeviceResponse = .failure(error: UpdateDeviceDetailsErrorResolver().resolve(serverError))
        case .success(payload: _):             //For now the server doesn't return a user
            updateCurrentDeviceResponse = .success(())
        }
        
        updateCurrentDeviceClosure(updateCurrentDeviceResponse)
    }
    
    fileprivate func checkInputValidity(id: String, userInfo: UserInfo?, customSettings: [String: Any]?) -> Bool {
        var atLeastOneParamExists: Bool
        
        if userInfo == nil && customSettings == nil {
            atLeastOneParamExists = false
        }
        else {
            atLeastOneParamExists = true
        }
        
        return atLeastOneParamExists && !id.isTrimmedEmpty()
   }
    
    private func addUserGeneralParamsToAnalytics (userMe: UserMe) {
        let userGeneralParamsRepo = CopilotUserGeneralParametersRepository(signUpMethod: userMe.accountStatus.credentialsType, userId: userMe.userDetails.id, userEmail: userMe.userDetails.email)
        AnalyticsEventsManager.sharedInstance.sessionBasedAnalyticsRepository.addGeneralParamsForCurrentSession(generalParamsForSession: userGeneralParamsRepo)
        AnalyticsEventsManager.sharedInstance.eventsDispatcher.setUserId(userId: userMe.userDetails.id)
    }
    
    private func handleAnalyticsConsent(from user: UserMe) {
        
        guard let isGDPRCompliant = configurationProvider.isGdprCompliant, isGDPRCompliant == true else {
            return
        }
        
        var hasAcceptedAnalyticsConsent = false
        
        hasAcceptedAnalyticsConsent = user.accountStatus.copilotUserAnalysisConsent == .accept

        // update the providers according to the updated user consents
        AnalyticsEventsManager.sharedInstance.updateConsent(with: hasAcceptedAnalyticsConsent)
    }
}


extension UserServiceInteraction: UserServiceInteractable {

    internal func deleteMe(deleteUserClosure: @escaping (Response<Void, DeleteUserError>) -> Void) {
        let deleteService = UserService.delete

        authenticatedRequestExecuter.executeRequest(target: deleteService) { response in
            var deleteUserResponse: Response<Void, DeleteUserError>
            switch response {
            case .success:
                self.authenticationApi.logout { _ in }
                deleteUserResponse = .success(())
            case .failure(error: let serverError):
                deleteUserResponse = .failure(error: DeleteUserErrorResolver().resolve(serverError))
            }
            deleteUserClosure(deleteUserResponse)
        }
    }

    internal func me(getCurrentUserClosure: @escaping GetCurrentUserClosure) {
        let meService = UserService.me
        
        authenticatedRequestExecuter.executeRequest(target: meService) { [weak self] (requestExecuterResponse) in
            if let weakSelf = self {
                weakSelf.handleGetCurrentUserExecuterResult(requestExecuterResponse, getCurrnetUserClosure: getCurrentUserClosure)
            }
            else {
                ZLogManagerWrapper.sharedInstance.logError(message: "self is nil")
            }
        }
    }
    
    internal func updateUser(id: String, userInfo: UserInfo?, customSettings: [String: Any]?, updateUserClosure: @escaping UpdateUserClosure) {
        guard checkInputValidity(id: id, userInfo: userInfo, customSettings: customSettings) else {
            DispatchQueue.global().async {
                updateUserClosure(.failure(error: .invalidParameters(debugMessage: "User id can't be empty and at least one of userInfo and customSettings should exist")))
            }
            ZLogManagerWrapper.sharedInstance.logError(message: "User id can't be empty and at least one of userInfo and customSettings should exist")
            return
        }
        
        let updateUserService = UserService.updateUser(id: id, userInfo: userInfo, customSettings: customSettings)
        authenticatedRequestExecuter.executeRequest(target: updateUserService) { [weak self] (requestExecuterResponse) in
            if let _ = self {
                self?.handleUpdateUserExecuterResult(requestExecuterResponse, updateUserClosure: updateUserClosure)
            }
            else {
                ZLogManagerWrapper.sharedInstance.logError(message: "self is nil")
            }
        }
    }
    
    internal func updateDeviceDetails(copilotSdkVersion: String, pnsToken: Data, isSandbox: Bool, updateCurrentDeviceClosure: @escaping UpdateDeviceDetailsClosure) {
        let deviceDetails = AnalyticsParameterProvider.kAnalyticsParametersDeviceDetails
        
        let updateCurrentDeviceService = UserService.updateDeviceDetails(copilotSdkVersion: copilotSdkVersion, pnsToken: pnsToken, isSandbox: isSandbox, deviceDetails: deviceDetails)
        
        authenticatedRequestExecuter.executeRequest(target: updateCurrentDeviceService) { [weak self] (requestExecuterResponse) in
            if let _ = self {
                self?.handleUpdateCurrentDeviceExecutorResult(requestExecuterResponse, updateCurrentDeviceClosure: updateCurrentDeviceClosure)
            }
            else {
                ZLogManagerWrapper.sharedInstance.logError(message: "self is nil")
            }
        }
    }
}
