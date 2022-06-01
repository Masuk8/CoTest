//
//  UserServiceInteractionClosures.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 11/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

typealias GetCurrentUserClosure = (Response<UserMe, FetchMeError>) -> Void
typealias UpdateUserClosure = (Response<UserMe, UpdateUserDetailsError>) -> Void
typealias UpdateDeviceDetailsClosure = (Response<Void, UpdateDeviceDetailsError>) -> Void
