//
//  ThingConsts.swift
//  CopilotAPIAccess
//
//  Created by Revital Pisman on 27/10/2019.
//  Copyright © 2019 Zemingo. All rights reserved.
//

import Foundation

struct ThingConsts {
    
    // If x < 'minimumSupportedEpoch' so x in milliseconds will be before 1970-02-17T11:34:04.800Z. While in seconds this number is a date in the year 2131.
    static let minimumSupportedEpoch: Double = 5097600000
}
