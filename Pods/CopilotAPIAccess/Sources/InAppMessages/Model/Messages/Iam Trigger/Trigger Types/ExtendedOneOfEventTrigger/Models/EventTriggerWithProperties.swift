//
//  EventTriggerWithProperties.swift
//  CopilotAPIAccess
//
//  Created by Elad on 25/04/2021.
//  Copyright © 2021 Zemingo. All rights reserved.
//

import Foundation

struct EventTriggerWithProperties {
    
    //MARK: - Consts
    private struct Keys {
        static let name = "name"
        static let conditionType = "conditionType"
        static let propertyTriggers = "propertyTriggers"
    }
    
    //MARK: - Properties
    let name: String
    let conditionType: ConditionType
    let propertyTriggers: [PropertyTrigger]
    
    // MARK: - Init
    init?(withDictionary dictionary: [String: Any]) {
        guard let name = dictionary[Keys.name] as? String,
              let conditionValue = dictionary[Keys.conditionType] as? String,
              let conditionType = ConditionType(rawValue: conditionValue),
              let propertyTriggerArr = dictionary[Keys.propertyTriggers] as? [[String: Any]],
              let propertyTriggers = EventTriggerWithProperties.propertyTriggersValidator(of: propertyTriggerArr)
              else { return nil }
    
        self.conditionType = conditionType
        self.name = name
        self.propertyTriggers = propertyTriggers
    }
    
    private static func propertyTriggersValidator(of propertyTriggers: [[String: Any]]) -> [PropertyTrigger]? {
        var propertyTriggersToReturn: [PropertyTrigger]? = []
        for propertyTrigger in propertyTriggers {
            if let validListPropertyTrigger = ListPropertyTrigger(withDictionary: propertyTrigger)  {
                propertyTriggersToReturn?.append(validListPropertyTrigger)
            } else if let validNumericPropertyTrigger = NumericPropertyTrigger(withDictionary: propertyTrigger) {
                propertyTriggersToReturn?.append(validNumericPropertyTrigger)
            } else {
                propertyTriggersToReturn = nil
                break
            }
        }
        return propertyTriggersToReturn
    }
}
