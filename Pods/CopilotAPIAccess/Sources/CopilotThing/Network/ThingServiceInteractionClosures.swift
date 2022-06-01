//
//  ThingServiceInteractionClosures.swift
//  CopilotAPIAccess
//
//  Created by Richard Houta on 11/10/2018.
//  Copyright © 2018 Zemingo. All rights reserved.
//

import Foundation

typealias UpdateThingClosure = (Response<Thing, UpdateThingError>) -> Void
typealias CanAssociateThingClosure = (Response<CanAssociateResponse, CanAssociateThingError>) -> Void
typealias AssociateThingClosure = (Response<Thing, AssociateThingError>) -> Void
typealias DisassociateThingClosure = (Response<Void, DisassociateThingError>) -> Void
typealias GetThingClosure = (Response<Thing, FetchSingleThingError>) -> Void
typealias GetThingsClosure = (Response<[Thing], FetchThingsError>) -> Void
