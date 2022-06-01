//
//  Dependencies.swift
//  CopilotAPIAccess
//
//  Created by Ofer Meroz on 23/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation


protocol HasAuthenticationServiceInteraction {
    var authenticationServiceInteraction: AuthenticationServiceInteractable { get }
}

protocol HasAuthenticationProvider {
    var authenticationProvider: AuthenticationProvider { get }
}

protocol HasUserServiceInteraction {
    var userServiceInteraction: UserServiceInteractable { get }
}

protocol HasSystemConfigurationServiceInteraction {
    var configurationServiceInteraction: SystemConfigurationServiceInteractable { get }
}

protocol HasThingsServiceInteraction {
    var thingsServiceInteraction: ThingsServiceInteractable { get }
}

protocol HasDocumentStorageServiceInteraction {
    var documentStorageInteraction: DocumentStorageInteractable { get }
}

protocol HasReporter {
    var reporter: ReportAPIAccess { get }
}

protocol HasConfigurationProvider {
    var configurationProvider: ConfigurationProvider { get }
}

protocol HasInAppServiceInteraction {
    var inAppServiceInteraction: InAppServiceInteraction { get }
}


struct ConnectDependencies: HasAuthenticationServiceInteraction, HasAuthenticationProvider, HasUserServiceInteraction, HasSystemConfigurationServiceInteraction, HasThingsServiceInteraction, HasReporter, HasConfigurationProvider {
    let authenticationServiceInteraction: AuthenticationServiceInteractable
    let authenticationProvider: AuthenticationProvider
    let userServiceInteraction: UserServiceInteractable
    let configurationServiceInteraction: SystemConfigurationServiceInteractable
    let thingsServiceInteraction: ThingsServiceInteractable
    let reporter: ReportAPIAccess
    let configurationProvider: ConfigurationProvider
}

struct CopilotDependencies: HasAuthenticationProvider {
    let authenticationProvider: AuthenticationProvider
}

struct InAppDependencies: HasReporter, HasInAppServiceInteraction  {
    let inAppServiceInteraction: InAppServiceInteraction
    let reporter: ReportAPIAccess
}
