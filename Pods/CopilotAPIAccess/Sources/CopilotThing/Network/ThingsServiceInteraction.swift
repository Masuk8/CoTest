//
//  ThingsServiceInteraction.swift
//  Things
//
//  Created by Yulia Felberg on 29/10/2017.
//  Copyright © 2017 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

protocol ThingsServiceInteractable {
    func getAssociatedThings(getThingsClosure: @escaping GetThingsClosure)
    func getAssociatedSingleThing(physicalID: String, getThingClosure: @escaping GetThingClosure)
    func canAssociateThing(physicalID: String, canAssociateThingClosure: @escaping CanAssociateThingClosure)
    func associateThing(firmware: String, model: String, physicalID: String, associateThingClosure: @escaping AssociateThingClosure)
    func disassociateThing(physicalID: String, disassociateThingClosure: @escaping DisassociateThingClosure)
    func updateAssociatedThing(physicalID: String, firmware: String?, name: String?, customSettings: [String:Any]?, thingStatus: ThingStatus?, updateThingClosure: @escaping UpdateThingClosure)
}

class ThingsServiceInteraction {
    
    fileprivate let authenticatedRequestExecquter: AuthenticatedRequestExecutor<ThingsService>
    
    // MARK: - Init
    
    init(authenticationProvider: AuthenticationProvider, sequentialExecutionHelper: MoyaSequentialExecutionHelper) {
        authenticatedRequestExecquter = AuthenticatedRequestExecutor<ThingsService>(authenticationProvider: authenticationProvider, sequentialExecutionHelper: sequentialExecutionHelper)
    }
    
    //MARK: Private
    
    fileprivate func handleUpdateThingExecuterResult(_ response: RequestExecutorResponse, updateThingClosure: UpdateThingClosure) {
        var updateThingResponse: Response<Thing, UpdateThingError>
        
        switch response {
        case .failure(error: let serverError):
            updateThingResponse = .failure(error: UpdateThingErrorResolver().resolve(serverError))
        case .success(payload: let dictionary):
            if let thing = Thing(withDictionary: dictionary) {
                updateThingResponse = .success(thing)
            }
            else {
                updateThingResponse = .failure(error: .generalError(debugMessage: "Failed to create thing from dictionary: \(dictionary)"))
            }
        }
        
        updateThingClosure(updateThingResponse)
    }
    
    fileprivate func handleCanAssociateThingExecuterResult(_ response: RequestExecutorResponse, canAssociateThingClosure: CanAssociateThingClosure) {
        var canAssociateThingResponse: Response<CanAssociateResponse, CanAssociateThingError>
        
        switch response {
        case .failure(error: let serverError):
            canAssociateThingResponse = .failure(error: CanAssociateThingErrorResolver().resolve(serverError))
            
        case .success(payload: let dictionary):
            if let canAss = CanAssociateResponse(withDictionary: dictionary) {
                canAssociateThingResponse = .success(canAss)
            }
            else {
                canAssociateThingResponse = .failure(error: .generalError(debugMessage:  "Failed to create can associate from dictionary: \(dictionary)"))
            }
        }
        
        canAssociateThingClosure(canAssociateThingResponse)
    }
    
    fileprivate func handleAssociateThingExecuterResult(_ response: RequestExecutorResponse, associateThingClosure: AssociateThingClosure) {
        var associateThingResponse: Response<Thing, AssociateThingError>
        
        switch response {
        case .failure(error: let serverError):
            
            associateThingResponse = .failure(error: AssociateThingErrorResolver().resolve(serverError))
        case .success(payload: let dictionary):
            if let thing = Thing(withDictionary: dictionary) {
                associateThingResponse = .success(thing)
            }
            else {
                associateThingResponse = .failure(error: .generalError(debugMessage: "Failed to create thing from dictionary: \(dictionary)"))
            }
        }
        
        associateThingClosure(associateThingResponse)
    }
    
    fileprivate func handleDisassociateThingExecuterResult(_ response: RequestExecutorResponse, disassociateThingClosure: DisassociateThingClosure) {
        var disassociateThingResponse: Response<Void, DisassociateThingError>
        
        switch response {
        case .failure(error: let serverError):
            
            disassociateThingResponse = .failure(error: DisassociateThingErrorResolver().resolve(serverError))
        case .success(payload: _):
            disassociateThingResponse = .success(())
        }
        
        disassociateThingClosure(disassociateThingResponse)
    }
    
    fileprivate func handleGetThingsExecuterResult(_ response: RequestExecutorResponse, getThingClosure: GetThingsClosure) {
        var getThingsResponse: Response<[Thing], FetchThingsError>
        
        switch response {
        case .failure(error: let serverError):
            
                getThingsResponse = .failure(error: FetchThingsErrorResolver().resolve(serverError))
            
        case .success(payload: let dictionary):
            
            var userThings = [Thing]()
            
            if let thingsArray = ThingServiceParamsInterpreter.getThingsArrayFromDictionary(thingsDictionary: dictionary) {
                
                thingsArray.forEach({ (singlethingDictionary) in
                    if let thing = Thing(withDictionary: singlethingDictionary) {
                        userThings.append(thing)
                    }
                })
                
                if !thingsArray.isEmpty && userThings.isEmpty {
                    getThingsResponse = .failure(error: .generalError(debugMessage: "Failed to create things from things array: \(thingsArray)"))
                }
                else {
                    getThingsResponse = .success(userThings)
                }
            }
            else {
                getThingsResponse = .failure(error: .generalError(debugMessage: "Could not find things from dictionary: \(dictionary)"))
            }
        }
        
        getThingClosure(getThingsResponse)
    }
    
    fileprivate func handleGetSingleThingExecuterResult(_ response: RequestExecutorResponse, getThingClosure: GetThingClosure) {
        var getSingleThingResponse: Response<Thing, FetchSingleThingError>
        
        switch response {
        case .failure(error: let serverError):
                getSingleThingResponse = .failure(error: FetchSingleThingErrorResolver().resolve(serverError))
        case .success(payload: let dictionary):
            if let thing = Thing(withDictionary: dictionary) {
                getSingleThingResponse = .success(thing)
            }
            else {
                getSingleThingResponse = .failure(error: .generalError(debugMessage: "Failed to create thing from dictionary: \(dictionary)"))
            }
        }
        
        getThingClosure(getSingleThingResponse)
    }
    
    fileprivate func checkInputValidity(physicalID: String, firmware: String?, name: String?, customSettings: [String: Any]?, thingStatus: ThingStatus?) -> Bool {
        var atLeastOneParamExists: Bool
        
        if firmware == nil && name == nil && customSettings == nil && thingStatus == nil {
            atLeastOneParamExists = false
        }
        else {
            atLeastOneParamExists = true
        }
        
        return atLeastOneParamExists && !physicalID.isTrimmedEmpty()
    }
}


extension ThingsServiceInteraction: ThingsServiceInteractable {
   
    
    func getAssociatedThings(getThingsClosure: @escaping GetThingsClosure) {
        let getThingsService = ThingsService.getAssociatedThings
        
        authenticatedRequestExecquter.executeRequest(target: getThingsService) {  [weak self] (requestExecuterResponse) in
            if let weakSelf = self {
                weakSelf.handleGetThingsExecuterResult(requestExecuterResponse, getThingClosure: getThingsClosure)
            }
            else {
                ZLogManagerWrapper.sharedInstance.logError(message: "self is nil")
            }
        }
    }
    
    func getAssociatedSingleThing(physicalID: String, getThingClosure: @escaping GetThingClosure) {
        guard !physicalID.isTrimmedEmpty() else {
            DispatchQueue.global().async {
                getThingClosure(.failure(error: .invalidParameters(debugMessage: "physicalID can't be empty")))
            }
            ZLogManagerWrapper.sharedInstance.logError(message: "physicalID can't be empty")
            return
        }
        
        let getSingleThingService = ThingsService.getAssociatedSingleThing(physicalID: physicalID)
        
        authenticatedRequestExecquter.executeRequest(target: getSingleThingService) {  [weak self] (requestExecuterResponse) in
            if let weakSelf = self {
                weakSelf.handleGetSingleThingExecuterResult(requestExecuterResponse, getThingClosure: getThingClosure)
            }
            else {
                ZLogManagerWrapper.sharedInstance.logError(message: "self is nil")
            }
        }
    }
        
    func canAssociateThing(physicalID: String, canAssociateThingClosure: @escaping CanAssociateThingClosure) {
        let canAssociateThingService = ThingsService.canAssociateThing(physicalID: physicalID)
        
        authenticatedRequestExecquter.executeRequest(target: canAssociateThingService) {  [weak self] (requestExecuterResponse) in
            if let weakSelf = self {
                weakSelf.handleCanAssociateThingExecuterResult(requestExecuterResponse, canAssociateThingClosure: canAssociateThingClosure)
            }
            else {
                ZLogManagerWrapper.sharedInstance.logError(message: "self is nil")
            }
        }
    }
    
    
    func associateThing(firmware: String, model: String, physicalID: String, associateThingClosure: @escaping AssociateThingClosure) {
        
        let associateThingService = ThingsService.associateThing(firmware: firmware, model: model, physicalID: physicalID)
        
        authenticatedRequestExecquter.executeRequest(target: associateThingService) {  [weak self] (requestExecuterResponse) in
            if let weakSelf = self {
                weakSelf.handleAssociateThingExecuterResult(requestExecuterResponse, associateThingClosure: associateThingClosure)
            }
            else {
                ZLogManagerWrapper.sharedInstance.logError(message: "self is nil")
            }
        }
    }
    
    
    func disassociateThing(physicalID: String, disassociateThingClosure: @escaping DisassociateThingClosure) {
        let disassociateThingService = ThingsService.disassociateThing(physicalID: physicalID)
        
        authenticatedRequestExecquter.executeRequest(target: disassociateThingService) {  [weak self] (requestExecuterResponse) in
            if let weakSelf = self {
                weakSelf.handleDisassociateThingExecuterResult(requestExecuterResponse, disassociateThingClosure: disassociateThingClosure)
            }
            else {
                ZLogManagerWrapper.sharedInstance.logError(message: "self is nil")
            }
        }
    }
    
    func updateAssociatedThing(physicalID: String, firmware: String?, name: String?, customSettings: [String:Any]?, thingStatus: ThingStatus?, updateThingClosure: @escaping UpdateThingClosure) {
        
        guard checkInputValidity(physicalID: physicalID, firmware: firmware, name: name, customSettings: customSettings, thingStatus: thingStatus) else {
            DispatchQueue.global().async {
                updateThingClosure(.failure(error: .invalidParameters(debugMessage: "physicalID can't be empty and at least one value should exist")))
            }
            ZLogManagerWrapper.sharedInstance.logError(message: "At least one value should exist")
            return
        }
        
        let updateThingService = ThingsService.updateAssociatedThing(physicalID: physicalID, firmware: firmware, name: name, customSettings: customSettings, thingStatus: thingStatus)
        
        authenticatedRequestExecquter.executeRequest(target: updateThingService) {  [weak self] (requestExecuterResponse) in
            if let weakSelf = self {
                weakSelf.handleUpdateThingExecuterResult(requestExecuterResponse, updateThingClosure: updateThingClosure)
            }
            else {
                ZLogManagerWrapper.sharedInstance.logError(message: "self is nil")
            }
        }
    }
}
