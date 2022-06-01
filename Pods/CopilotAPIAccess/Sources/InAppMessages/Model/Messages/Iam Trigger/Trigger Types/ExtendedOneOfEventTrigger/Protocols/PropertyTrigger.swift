//
//  PropertyTrigger.swift
//  CopilotAPIAccess
//
//  Created by Elad on 25/04/2021.
//  Copyright © 2021 Zemingo. All rights reserved.
//

import Foundation

protocol PropertyTrigger {

    //MARK: - Properties
    var filterType: FilterType { get }
    var propertyName: String { get }
    
    //MARK: - Functions
    func match(firedEventParameters: [String : String]) -> Bool
}
