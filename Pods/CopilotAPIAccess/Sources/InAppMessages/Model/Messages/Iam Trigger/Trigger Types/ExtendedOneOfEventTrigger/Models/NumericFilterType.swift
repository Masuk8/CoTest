//
//  NumericFilterType.swift
//  CopilotAPIAccess
//
//  Created by Elad on 25/04/2021.
//  Copyright © 2021 Zemingo. All rights reserved.
//

import Foundation

enum NumericFilterType: String, FilterType {
    case greaterThen = "GreaterThan"
    case equals = "Equals"
    case greaterThanOrEquals = "GreaterThanOrEquals"
    case lowerThan = "LowerThan"
    case lowerThanOrEquals = "LowerThanOrEquals"
}
